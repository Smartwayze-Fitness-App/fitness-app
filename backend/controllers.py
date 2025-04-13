from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from models import db, User, WorkoutPlan, Exercise, Progress,WorkoutLog
from datetime import datetime

api = Blueprint('api', __name__)

# ---------- USER APIs ----------

@api.route('/register', methods=['POST'])
def register_user():
    data = request.json
    if User.query.filter_by(email=data['email']).first():
        return jsonify({"error": "Email already registered"}), 400

    hashed_password = generate_password_hash(data['password'])

    new_user = User(
        username=data['username'],
        email=data['email'],
        password=hashed_password,
        name=data.get('name'),
        age=data.get('age'),
        gender=data.get('gender'),
        weight=data.get('weight'),
        height=data.get('height'),
        profile_picture=data.get('profile_picture'),
        created_at=datetime.utcnow()
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully", "user_id": new_user.id})


@api.route('/api/users/login', methods=['POST'])
def login_user():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()

    if not user or not check_password_hash(user.password, data['password']):
        return jsonify({"error": "Invalid email or password"}), 401

    return jsonify({
        "message": "Login successful",
        "user": {
            "id": user.id,
            "username": user.username,
            "email": user.email,
            "name": user.name
        }
    })
#------------user profile ApIs----------------

# def create_user():
#     data = request.json
#     if User.query.filter_by(email=data['email']).first():
#         return jsonify({"error": "Email already registered"}), 400
    
#     hashed_password = generate_password_hash(data['password'])

#     new_user = User(
#         username=data['username'],
#         email=data['email'],
#         password=hashed_password,
#         name=data.get('name'),
#         age=data.get('age'),
#         gender=data.get('gender'),
#         weight=data.get('weight'),
#         height=data.get('height'),
#         profile_picture=data.get('profile_picture')
#     )
#     db.session.add(new_user)
#     db.session.commit()

#     return jsonify({"message": "User created", "user_id": new_user.id})

# Read User
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "name": user.name,
        "age": user.age,
        "gender": user.gender,
        "weight": user.weight,
        "height": user.height,
        "profile_picture": user.profile_picture,
        "created_at": user.created_at,
        "updated_at": user.updated_at
    })

# Update User
def update_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    data = request.json

    user.username = data.get('username', user.username)
    user.email = data.get('email', user.email)
    if 'password' in data:
        user.password = generate_password_hash(data['password'])
    user.name = data.get('name', user.name)
    user.age = data.get('age', user.age)
    user.gender = data.get('gender', user.gender)
    user.weight = data.get('weight', user.weight)
    user.height = data.get('height', user.height)
    user.profile_picture = data.get('profile_picture', user.profile_picture)
    user.updated_at = datetime.utcnow()

    db.session.commit()

    return jsonify({"message": "User updated successfully"})

# Delete User
def delete_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    db.session.delete(user)
    db.session.commit()
    return jsonify({"message": "User deleted successfully"})




# Set fitness level and goal
def set_fitness_profile(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    data = request.json
    user.fitness_level = data.get("fitness_level", user.fitness_level)
    user.fitness_goal = data.get("fitness_goal", user.fitness_goal)
    user.updated_at = datetime.utcnow()

    db.session.commit()
    return jsonify({"message": "Fitness profile updated successfully"})

# Get fitness profile
def get_fitness_profile(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "user_id": user.id,
        "fitness_level": user.fitness_level,
        "fitness_goal": user.fitness_goal
    })

# ---------- WORKOUT APIs ----------

@api.route('/api/workouts', methods=['POST'])
def create_custom_workout():
    data = request.json
    plan = WorkoutPlan(
        title=data['title'],
        category=data['category'],
        description=data['description'],
        duration=data['duration'],
        difficulty=data['difficulty'],
        created_by=data['created_by'],
        is_prebuilt=False,
        created_at=datetime.utcnow()
    )
    db.session.add(plan)
    db.session.commit()

    for ex in data['exercises']:
        exercise = Exercise(
            workout_id=plan.id,
            exercise_name=ex['exercise_name'],
            sets=ex.get('sets'),
            reps=ex.get('reps'),
            rest_time=ex.get('rest_time')
        )
        db.session.add(exercise)

    db.session.commit()
    return jsonify({"message": "Workout plan created", "plan_id": plan.id})


@api.route('/api/workouts', methods=['GET'])
def get_workout_plans():
    plans = WorkoutPlan.query.all()
    return jsonify([serialize_workout(plan) for plan in plans])


@api.route('/api/workouts/prebuilt', methods=['GET'])
def get_prebuilt_plans():
    plans = WorkoutPlan.query.filter_by(is_prebuilt=True).all()
    return jsonify([serialize_workout(plan) for plan in plans])


@api.route('/api/workouts/categories', methods=['GET'])
def get_categories():
    categories = db.session.query(WorkoutPlan.category).distinct()
    return jsonify([cat[0] for cat in categories])


@api.route('/api/workouts/category/<string:category>', methods=['GET'])
def get_plans_by_category(category):
    plans = WorkoutPlan.query.filter_by(category=category).all()
    return jsonify([serialize_workout(plan) for plan in plans])


def serialize_workout(plan):
    return {
        "id": plan.id,
        "title": plan.title,
        "category": plan.category,
        "description": plan.description,
        "duration": plan.duration,
        "difficulty": plan.difficulty,
        "created_by": plan.created_by,
        "is_prebuilt": plan.is_prebuilt,
        "exercises": [{
            "exercise_name": ex.exercise_name,
            "sets": ex.sets,
            "reps": ex.reps,
            "rest_time": ex.rest_time
        } for ex in plan.exercises],
        "created_at": plan.created_at
    }


# ---------- PROGRESS APIs ----------

@api.route('/api/progress', methods=['POST'])
def track_progress():
    data = request.json
    progress = Progress(
        user_id=data['user_id'],
        date=datetime.utcnow().date(),
        weight=data.get('weight'),
        workouts_completed=data.get('workouts_completed', 0),
        calories_burned=data.get('calories_burned', 0),
        notes=data.get('notes', ''),
        created_at=datetime.utcnow()
    )
    db.session.add(progress)
    db.session.commit()
    return jsonify({"message": "Progress saved"})


@api.route('/api/progress/<int:user_id>', methods=['GET'])
def get_user_progress(user_id):
    progress_list = Progress.query.filter_by(user_id=user_id).all()
    return jsonify([{
        "date": p.date,
        "weight": p.weight,
        "workouts_completed": p.workouts_completed,
        "calories_burned": p.calories_burned,
        "notes": p.notes
    } for p in progress_list])


#-----------

def log_workout_progress():
    data = request.json
    log = WorkoutLog(
        user_id=data['user_id'],
        workout_id=data['workout_id'],
        date=datetime.strptime(data['date'], "%Y-%m-%d").date(),
        completed_exercises=data.get('completed_exercises'),
        duration=data.get('duration'),
        calories_burned=data.get('calories_burned'),
        notes=data.get('notes')
    )
    db.session.add(log)
    db.session.commit()
    return jsonify({"message": "Workout log saved successfully"}), 201

def get_workout_logs(user_id):
    logs = WorkoutLog.query.filter_by(user_id=user_id).order_by(WorkoutLog.date.desc()).all()
    return jsonify([
        {
            "date": log.date.isoformat(),
            "workout_id": log.workout_id,
            "completed_exercises": log.completed_exercises,
            "duration": log.duration,
            "calories_burned": log.calories_burned,
            "notes": log.notes,
            "created_at": log.created_at.isoformat()
        }
        for log in logs
    ])
