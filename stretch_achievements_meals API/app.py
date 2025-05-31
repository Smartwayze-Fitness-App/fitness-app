from flask import Flask, request, jsonify
from flask_cors import CORS
from models import db, StretchSession, Meal, Achievement
from datetime import datetime
import os


app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(os.path.abspath(os.path.dirname(__file__)), 'database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()
@app.route('/api/stretch', methods=['POST'])
def mark_stretch():
    data = request.get_json()

    # Validate input
    if not data or 'user_id' not in data:
        return jsonify({'error': 'Missing user_id'}), 400

    timestamp = data.get('timestamp')
    if timestamp:
        timestamp = timestamp  # Already string format
    else:
        timestamp = datetime.utcnow().isoformat()

    session = StretchSession(user_id=data['user_id'], timestamp=timestamp)
    db.session.add(session)
    db.session.commit()
    return jsonify({'message': 'Stretch session recorded'}), 201



@app.route('/api/stretch/<user_id>', methods=['GET'])
def get_stretch(user_id):
    sessions = StretchSession.query.filter_by(user_id=user_id).all()
    data = [{'id': s.id, 'timestamp': s.timestamp} for s in sessions]
    return jsonify({
        'total_sessions': len(sessions),
        'sessions': data
    })


@app.route('/api/meals', methods=['POST'])
def log_meal():
    data = request.get_json()
    print("Received meal data:", data)

    # Validate required fields
    if not data or 'user_id' not in data or 'calories' not in data:
        return jsonify({'error': 'Missing required fields'}), 400

    # Convert timestamp to datetime, or use current time
    timestamp = data.get('timestamp')
    if timestamp:
        timestamp = datetime.fromisoformat(timestamp)
    else:
        timestamp = datetime.utcnow()

    # Create meal entry
    meal = Meal(
        user_id=data['user_id'],
        calories=data['calories'],
         meal_name=data.get('meal_name'),
        timestamp=timestamp
    )
    db.session.add(meal)
    db.session.commit()
    return jsonify({'message': 'Meal logged successfully'}), 201



@app.route('/api/meals/<user_id>', methods=['GET'])
def get_meals(user_id):
    today = datetime.today().date()
    meals = Meal.query.filter_by(user_id=user_id).all()
    today_meals = [m for m in meals if m.timestamp.date() == today]
    total = sum(m.calories for m in today_meals)
    return jsonify({'calories_today': total})

@app.route('/api/achievements/<user_id>', methods=['GET'])
def check_achievement(user_id):
    sessions = StretchSession.query.filter_by(user_id=user_id).all()
    count = len(sessions)

    # Check and unlock achievement if not already
    achievement = Achievement.query.filter_by(user_id=user_id, type="3_sessions").first()
    if count >= 3:
        if not achievement:
            new_ach = Achievement(user_id=user_id, type="3_sessions", unlocked=True)
            db.session.add(new_ach)
            db.session.commit()
        elif not achievement.unlocked:
            achievement.unlocked = True
            db.session.commit()

    # Return all achievements
    all_achievements = Achievement.query.filter_by(user_id=user_id).all()
    data = [{'type': a.type, 'unlocked': a.unlocked} for a in all_achievements]
    return jsonify({'achievements': data})


if __name__ == '__main__':
    app.run(debug=True)
