import hashlib
import os
import io
import random
import re
from flask import Flask, flash, render_template, make_response, request, redirect, session, url_for, abort, send_file
from flask_mail import Mail, Message  # Asegúrate de usar Message de flask_mail
from flask_mysqldb import MySQL
import MySQLdb
from config import Config
from functools import wraps


app = Flask(__name__)
app.config.from_object(Config)
app.secret_key = 'tu_clave_secreta_aqui'
mysql = MySQL(app)


@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    correo = request.form['correo']

    # Verificar si el correo existe en la base de datos
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT correo FROM usuarios WHERE correo = %s", (correo,))
    user = cursor.fetchone()
    cursor.close()

    if user:
        # Si el correo existe, redirigir al formulario de restablecimiento de contraseña
        return redirect(url_for('reset_password', correo=correo))
    else:
        flash('No se encontró una cuenta asociada a ese correo electrónico.', 'error')
        return redirect(url_for('login'))



@app.route('/reset_password', methods=['GET', 'POST'])
def reset_password():
    correo = request.form.get('correo') or request.args.get('correo')

    if request.method == 'POST':
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']

        if new_password != confirm_password:
            flash('Las contraseñas no coinciden.', 'error')
            return redirect(url_for('reset_password', correo=correo))

        if validar_contraseña(new_password):  # Validar que la contraseña cumple los requisitos
            hashed_password = encrypt_password(new_password)

            if hashed_password is None:
                flash('Error al encriptar la contraseña.', 'error')
                return redirect(url_for('reset_password', correo=correo))

            cursor = mysql.connection.cursor()
            try:
                cursor.execute("UPDATE usuarios SET contraseña = %s WHERE correo = %s", (hashed_password, correo))
                mysql.connection.commit()

                if cursor.rowcount == 0:
                    flash('No se encontró el correo en la base de datos.', 'error')
                    return redirect(url_for('reset_password', correo=correo))

                flash('Tu contraseña ha sido actualizada correctamente.', 'success')
                return redirect(url_for('login'))
            except Exception as e:
                mysql.connection.rollback()
                flash('Ocurrió un error al actualizar la contraseña. Inténtalo de nuevo.', 'error')
                print(f"Error al actualizar la contraseña: {e}")
            finally:
                cursor.close()
        else:
            flash('La contraseña debe contener al menos una letra mayúscula, una letra minúscula y un número.', 'error-login')

    return render_template('reset_password.html', correo=correo)




# Función para encriptar contraseñas con SHA-1
def encrypt_password(password):
    return hashlib.sha1(password.encode()).hexdigest()


@app.route('/certificaciones', methods=['GET', 'POST'])
def certificaciones():
    if request.method == 'POST':
        # Recoger datos del formulario
        n_documento = request.form.get('nDocumento')
        made_by = request.form.get('madeBy')
        motivo_autorizacion = request.form.get('motivoAutorizacion')
        validaciones = request.form.getlist('vDoc')  # Es una lista de valores de checkboxes
        archivo_plano = request.form.get('aPlano')
        tipo_documento = request.form.get('tipoDocumento')
        nombre_completo = request.form.get('nombreCompleto')
        banco = request.form.get('banco')
        fecha_consignacion = request.form.get('dfecha')
        valor_consignacion = request.form.get('valorConsignacion')
        lugar_tramite = request.form.get('lTramite')
        observacion = request.form.get('observacion')

        # Validación de campos (esto es opcional y puedes ajustarlo según tus necesidades)
        if not n_documento or not nombre_completo or not motivo_autorizacion:
            flash('Por favor completa todos los campos obligatorios.', 'error')
            return redirect(url_for('certificaciones'))

        try:
            cursor = mysql.connection.cursor()
            # Ejemplo de inserción en la base de datos
            cursor.execute("""
                INSERT INTO certificaciones (n_documento, made_by, motivo_autorizacion, validaciones, archivo_plano, tipo_documento, nombre_completo, banco, fecha_consignacion, valor_consignacion, lugar_tramite, observacion)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (n_documento, made_by, motivo_autorizacion, ','.join(validaciones), archivo_plano, tipo_documento, nombre_completo, banco, fecha_consignacion, valor_consignacion, lugar_tramite, observacion))
            mysql.connection.commit()
            flash('Datos guardados exitosamente.', 'success')
        except Exception as e:
            mysql.connection.rollback()
            flash('Ocurrió un error al guardar los datos.', 'error')
        finally:
            cursor.close()
        
        return redirect(url_for('certificaciones'))

    return render_template('certificaciones.html')


@app.route('/index', methods=['GET', 'POST'])
def index():
    return render_template('index.html')

@app.route('/download/<filename>')
def download_file(filename):
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT nombre FROM archivos WHERE nombre = %s', (filename,))
    result = cursor.fetchone()
    
    if result:
        filename = result[0]

        # Busca en todas las subcarpetas dentro de _docs
        file_path = None
        for root, dirs, files in os.walk('_docs'):
            if filename in files:
                file_path = os.path.join(root, filename)
                break

        if file_path and os.path.exists(file_path):
            return send_file(file_path, as_attachment=True)
        else:
            abort(404, description="Archivo no encontrado en el sistema de archivos")
    else:
        abort(404, description="Archivo no encontrado en la base de datos")

@app.route('/footer')
def footer():
    return render_template('footer.html')

@app.route('/header')
def header():
    return render_template('header.html')


@app.route('/', methods=['GET', 'POST'])
def login():
    cursor = mysql.connection.cursor()
    if request.method == 'POST':
        usuario = request.form['usuario']
        contraseña = encrypt_password(request.form['contraseña'])

        cursor.execute("SELECT id, estado FROM usuarios WHERE usuario=%s AND contraseña=%s", (usuario, contraseña))
        usuario_data = cursor.fetchone()

        if usuario_data:
            if usuario_data[1] == 'A':  # Verificar que el estado sea activo
                session['usuario'] = usuario  # Almacenar el nombre de usuario en la sesión
                session['loggedin'] = True  # Establecer que el usuario ha iniciado sesión
                if usuario == 'admin':  # Si el usuario es 'admin'
                    return redirect(url_for('admin'))  # Redirigir a la página de administración
                return redirect(url_for('index'))  # Redirigir a la página de inicio por defecto
            else:
                flash("Tu cuenta está inactiva, contacta al administrador para activar tu cuenta.", 'login-warning')
        else:
            flash("Usuario o contraseña incorrectos", 'login-error')
        
    cursor.close()
    return render_template('login.html')


def validar_contraseña(contraseña):
    if (re.search(r'[A-Z]', contraseña) and   # Al menos una letra mayúscula
        re.search(r'[a-z]', contraseña) and   # Al menos una letra minúscula
        re.search(r'\d', contraseña)):        # Al menos un número
        return True
    return False

@app.route('/register', methods=['GET', 'POST'])
def register():
    cursor = mysql.connection.cursor()  # Definir el cursor aquí
    if request.method == 'POST':
        nombre = request.form['nombre']
        usuario = request.form['usuario']
        correo = request.form['correo']
        contraseña = encrypt_password(request.form['contraseña'])

        # Verificar si el correo termina en '@registraduria.gov.co'
        if not correo.endswith('@registraduria.gov.co'):
            flash("El correo debe ser de dominio @registraduria.gov.co.", 'register-error')
            return render_template('login.html')

        # Verificar si el usuario ya existe
        cursor.execute("SELECT id FROM usuarios WHERE usuario=%s", (usuario,))
        usuario_existente = cursor.fetchone()

        # Verificar si el correo ya existe
        cursor.execute("SELECT id FROM usuarios WHERE correo=%s", (correo,))
        correo_existente = cursor.fetchone()

        # Comprobar qué campos ya existen y generar mensajes específicos
        errores = []
        if usuario_existente:
            errores.append("El usuario ya está en uso.")
        if correo_existente:
            errores.append("El correo ya está en uso.")
        
        # Si hay errores, mostrar los mensajes
        if errores:
            flash(" ".join(errores), 'register-warning')
        else:
            try:
                cursor.execute("INSERT INTO usuarios (nombre, usuario, correo, contraseña, estado) VALUES (%s, %s, %s, %s, 'I')", 
                               (nombre, usuario, correo, contraseña))
                mysql.connection.commit()
                flash("Registro exitoso. ¡Ya puedes iniciar sesión!", 'login-success')
            except Exception as e:
                mysql.connection.rollback()  # Revertir en caso de error
                flash("Ocurrió un error al registrar. Inténtalo de nuevo.", 'register-error')

    cursor.close()  # Cerrar el cursor
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('usuario', None)
    
    flash('Sesión cerrada correctamente', 'login-success')
    
    resp = make_response(redirect(url_for('login')))
    resp.headers['Cache-Control'] = 'no-store'
    resp.headers['Pragma'] = 'no-cache'
    resp.headers['Expires'] = '0'
    return resp

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'loggedin' not in session or not session['loggedin']:
            flash('Debe iniciar sesión para acceder a esta página', 'login-warning')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


@app.after_request
def after_request(response):
    response.headers['Cache-Control'] = 'no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'pdf', 'doc'}
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
    
@app.route('/upload', methods=['GET'])
@login_required
def upload():
    cursor = mysql.connection.cursor()
    
    # Datos para los selectores
    cursor.execute("SELECT id_mp, descripcion FROM macroprocesos")
    macroprocesos = cursor.fetchall()
   
    cursor.execute("SELECT id_p, descripcion FROM procesos")
    procesos = cursor.fetchall()
   
    cursor.execute("SELECT id, descripcion FROM tipo_documento")
    documento = cursor.fetchall()

    # Generar un rango de años desde 1900 hasta 2070
    anios = list(range(1900, 2071))
    cursor.close()

    return render_template('upload.html', macroprocesos=macroprocesos, procesos=procesos, documento=documento, anios=anios)


# Ruta para mostrar la lista de usuarios y las acciones de habilitar, inhabilitar, editar y eliminar
@app.route('/admin')
@login_required  # Asegurarse de que esta ruta esté protegida por login
def admin():
    cursor = mysql.connection.cursor()
    # Excluir a los usuarios con rol 'admin'
    cursor.execute("SELECT * FROM usuarios WHERE usuario != 'admin'")
    usuarios = cursor.fetchall()
    cursor.close()
    return render_template('admin.html', usuarios=usuarios)


# Ruta para habilitar un usuario
@app.route('/habilitar/<int:id>')
@login_required
def habilitar_usuario(id):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE usuarios SET estado = 'A' WHERE id = %s", (id,))
    mysql.connection.commit()
    cursor.close()
    flash('Usuario habilitado correctamente', 'success')
    return redirect(url_for('admin'))

# Ruta para inhabilitar un usuario
@app.route('/inhabilitar/<int:id>')
@login_required
def inhabilitar_usuario(id):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE usuarios SET estado = 'I' WHERE id = %s", (id,))
    mysql.connection.commit()
    cursor.close()
    flash('Usuario inhabilitado correctamente', 'success')
    return redirect(url_for('admin'))

# Ruta para actualizar un usuario
@app.route('/actualizar_usuario/<int:id>', methods=['POST'])
@login_required
def actualizar_usuario(id):
    nombre = request.form['nombre']
    correo = request.form['correo']
    usuario = request.form['usuario']
    
    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE usuarios 
        SET nombre = %s, correo = %s, usuario = %s 
        WHERE id = %s
    """, (nombre, correo, usuario, id))
    mysql.connection.commit()
    cursor.close()
    
    flash('Usuario actualizado correctamente', 'success')
    return redirect(url_for('admin'))

if __name__ == '__main__':
    app.run(debug=app.config['DEBUG'], port=app.config['PORT'])
