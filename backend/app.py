from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory user store (email as key)
users = {}

# Register API
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    # Basic validation
    if not all([name, email, password, confirm_password]):
        return jsonify({'message': 'All fields are required'}), 400

    if email in users:
        return jsonify({'message': 'User already exists'}), 400

    if password != confirm_password:
        return jsonify({'message': 'Passwords do not match'}), 400

    users[email] = {
        'name': name,
        'email': email,
        'password': password  # NOTE: In production, hash the password!
    }

    return jsonify({'message': 'User registered successfully'}), 201

# Login API
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if email not in users:
        return jsonify({'message': 'User not found'}), 404

    if users[email]['password'] != password:
        return jsonify({'message': 'Incorrect password'}), 401

    return jsonify({'message': 'Login successful', 'name': users[email]['name']}), 200

if __name__ == '__main__':
    app.run(debug=True)
