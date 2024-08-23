import datetime
import os
import hashlib
from flask import Flask, flash, render_template, make_response, request, redirect, session, url_for, abort, send_file, jsonify
from flask_mysqldb import MySQL
import MySQLdb
from config import Config
import io
import math
from werkzeug.utils import secure_filename
from datetime import datetime
from functools import wraps

app = Flask(__name__)
app.config.from_object(Config)
app.secret_key = 'tu_clave_secreta_aqui'
mysql = MySQL(app)


@app.route('/', methods=['GET', 'POST'])
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
            with open(file_path, 'rb') as f:
                file_content = f.read()

            return send_file(
                io.BytesIO(file_content),
                download_name=filename,
                as_attachment=True
            )
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


# Función para encriptar la contraseña usando SHA-1 para que el password la lea 
def hash_password_sha1(password):
    return hashlib.sha1(password.encode()).hexdigest()

# Ruta de inicio de sesión
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM usuarios WHERE usuario = %s", (username,))
        user = cursor.fetchone()
        
        
        if user and hash_password_sha1(password) == user['pass']:
            if user['estado'] == 'I':  # Verifica si el usuario está inactivo
                flash('Este usuario está inactivo. No se puede iniciar sesión.', 'danger')
                return redirect(url_for('login'))
            session['loggedin'] = True
            session['id'] = user['nuip']
            session['username'] = user['usuario']
            session['nombres'] = user['nombres']
            flash('Inicio de sesión exitoso', 'success')
            return redirect(url_for('upload'))
        else:
            flash('Nombre de usuario o contraseña incorrectos', 'danger')
            return redirect(url_for('login'))

    return render_template('login.html')

#Para el cerrado de sesion
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    session.pop('nombres', None)
    
    flash('Sesión cerrada correctamente', 'success')
    
    resp = make_response(redirect(url_for('login')))
    resp.headers['Cache-Control'] = 'no-store'
    resp.headers['Pragma'] = 'no-cache'
    resp.headers['Expires'] = '0'
    return resp

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'loggedin' not in session:
            flash('Debe iniciar sesión para acceder a esta página', 'danger')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.after_request
def after_request(response):
    response.headers['Cache-Control'] = 'no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

#Para cargar documentos 
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

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

if __name__ == '__main__':
    app.run(debug=app.config['DEBUG'], port=app.config['PORT'])
