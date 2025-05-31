
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class StretchSession(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(50))
    timestamp = db.Column(db.String(100))

class Meal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(50), nullable=False)
    calories = db.Column(db.Integer, nullable=False)
    meal_name = db.Column(db.String)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)


class Achievement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(50))
    type = db.Column(db.String(50))  
    unlocked = db.Column(db.Boolean, default=False)
