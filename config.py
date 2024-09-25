import os

class Config:
    DEBUG = True
    PORT = 4002
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = ''
    MYSQL_DB = 'certificaciones_final'
    SECRET_KEY = os.urandom(24)