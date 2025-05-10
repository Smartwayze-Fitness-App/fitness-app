import os

basedir = os.path.abspath(os.path.dirname(__file__))
# jjijij
class Config:
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:21arid483fyp@localhost:3306/dbfitnessapp'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'zain1234'  # Used for JWT signing
    JWT_SECRET_KEY = 'zain1234'
    JWT_ACCESS_TOKEN_EXPIRES = 3600
