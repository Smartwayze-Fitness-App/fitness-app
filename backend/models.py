from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'  # Explicitly set table name to avoid conflicts
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(200), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    profile = db.relationship('UserProfile', backref='user', uselist=False, lazy=True)

class UserProfile(db.Model):
    __tablename__ = 'user_profiles'  # Explicitly set table name
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False, unique=True)
    username = db.Column(db.String(100), unique=True)
    age = db.Column(db.Integer)
    gender = db.Column(db.String(20))
    weight = db.Column(db.Float)
    height = db.Column(db.Float)
    profile_picture = db.Column(db.String(200))
    fitness_level = db.Column(db.String(20))  # e.g., beginner, intermediate, advanced
    fitness_goal = db.Column(db.String(100))  # e.g., weight loss, muscle gain
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class WorkoutPlan(db.Model):
    __tablename__ = 'workout_plans'  # Explicitly set for clarity
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    category = db.Column(db.String(50))
    description = db.Column(db.Text)
    duration = db.Column(db.Integer)
    difficulty = db.Column(db.String(50))
    is_prebuilt = db.Column(db.Boolean, default=False)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    exercises = db.relationship('Exercise', backref='workout', lazy=True)

class Exercise(db.Model):
    __tablename__ = 'exercises'  # Explicitly set for clarity
    id = db.Column(db.Integer, primary_key=True)
    workout_id = db.Column(db.Integer, db.ForeignKey('workout_plans.id'))
    exercise_name = db.Column(db.String(100))
    sets = db.Column(db.Integer)
    reps = db.Column(db.Integer)
    rest_time = db.Column(db.Integer)  # in seconds

class Meal(db.Model):
    __tablename__ = 'meals'  # Explicitly set for clarity
    id = db.Column(db.Integer, primary_key=True)
    meal_name = db.Column(db.String(100))
    meal_type = db.Column(db.String(50))  # Breakfast, Lunch, Dinner
    calories = db.Column(db.Integer)
    description = db.Column(db.Text)
    ingredients = db.Column(db.JSON)
    image_url = db.Column(db.String(255))
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class WorkoutLog(db.Model):
    __tablename__ = 'workout_logs'  # Explicitly set for clarity
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    workout_id = db.Column(db.Integer, db.ForeignKey('workout_plans.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    completed_exercises = db.Column(db.Text)  # You can store a JSON string or structured data
    duration = db.Column(db.Integer)  # Total workout duration in minutes
    calories_burned = db.Column(db.Integer)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class Progress(db.Model):
    __tablename__ = 'progress'  # Explicitly set for clarity
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    date = db.Column(db.Date)
    weight = db.Column(db.Float)
    workouts_completed = db.Column(db.Integer)
    calories_burned = db.Column(db.Integer)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)