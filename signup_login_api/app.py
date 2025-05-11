from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['JWT_SECRET_KEY'] = 'your_secret_key'

# Initialize Extensions
db = SQLAlchemy(app)
jwt = JWTManager(app)

# User Model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    contact = db.Column(db.String(20), nullable=False)
    age = db.Column(db.Integer)
    gender = db.Column(db.String(10))
    height = db.Column(db.Float)
    weight = db.Column(db.Float)
    fitness_goal = db.Column(db.String(100))
    fitness_level = db.Column(db.String(50))

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    required_fields = ['name', 'email', 'password', 'confirm_password', 'contact']
    for field in required_fields:
        if field not in data:
            return jsonify({"message": f"{field} is required"}), 400
    if data['password'] != data['confirm_password']:
        return jsonify({"message": "Passwords do not match"}), 400
    if User.query.filter_by(email=data['email']).first():
        return jsonify({"message": "Email already registered"}), 409
    new_user = User(
        name=data['name'],
        email=data['email'],
        password=data['password'],
        contact=data['contact']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully!"}), 201

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = User.query.filter_by(email=data['email'], password=data['password']).first()
    if user:
        access_token = create_access_token(identity=str(user.id))
        return jsonify(access_token=access_token)
    return jsonify({"message": "Invalid credentials"}), 401

@app.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    return jsonify({
        "name": user.name,
        "email": user.email,
        "contact": user.contact,
        "age": user.age,
        "gender": user.gender,
        "height": user.height,
        "weight": user.weight,
        "fitness_goal": user.fitness_goal,
        "fitness_level": user.fitness_level
    })

@app.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    data = request.get_json()
    user.name = data.get('name', user.name)
    user.age = data.get('age', user.age)
    user.gender = data.get('gender', user.gender)
    user.height = data.get('height', user.height)
    user.weight = data.get('weight', user.weight)
    user.fitness_goal = data.get('fitness_goal', user.fitness_goal)
    user.fitness_level = data.get('fitness_level', user.fitness_level)
    user.contact = data.get('contact', user.contact)
    db.session.commit()
    return jsonify({"message": "Profile updated successfully!"})
@app.route('/init-db')
def init_db():
    with app.app_context():
        db.create_all()
    return "Database created!"

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)