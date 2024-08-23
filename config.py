import os

class Config:
    DEBUG = True
    PORT = 4002
    MYSQL_HOST = '10.210.150.44'
    MYSQL_USER = 'daquinones'
    MYSQL_PASSWORD = 'Colombia123#'
    MYSQL_DB = 'normatividad'
    ALLOWED_EXTENSIONS = {'pdf', 'doc'}
    SECRET_KEY = os.urandom(24)