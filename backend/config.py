import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:21arid483fyp@localhost:3306/dbfitnessapp'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
