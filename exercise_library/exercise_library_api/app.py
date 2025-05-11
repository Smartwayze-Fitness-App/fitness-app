from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/exercises', methods=['GET'])
def get_exercises():
    exercises = [
        {
            "name": "Cardio Blast",
            "body_part": "Full Body",
            "equipment": "None",
            "difficulty": "Beginner",
            "instructions": "Run in place for 60 seconds, then jump rope for 1 minute."
        },
        {
            "name": "Strength Training",
            "body_part": "Upper Body",
            "equipment": "Dumbbells",
            "difficulty": "Intermediate",
            "instructions": "3 sets of bicep curls, shoulder press, and push-ups."
        },
        {
            "name": "Yoga Flow",
            "body_part": "Core",
            "equipment": "Yoga Mat",
            "difficulty": "Beginner",
            "instructions": "Perform sun salutations, cat-cow stretches, and cobra pose."
        },
        {
            "name": "HIIT Burn",
            "body_part": "Lower Body",
            "equipment": "Resistance Bands",
            "difficulty": "Advanced",
            "instructions": "Alternate 30s of jumping squats with 30s rest, 5 rounds."
        },
        {
            "name": "Flexibility Boost",
            "body_part": "Full Body",
            "equipment": "None",
            "difficulty": "Beginner",
            "instructions": "Perform static stretches for hamstrings, hips, and shoulders."
        },
        {
            "name": "Pilates Core",
            "body_part": "Abs",
            "equipment": "Pilates Ring",
            "difficulty": "Intermediate",
            "instructions": "Use ring for leg circles, bridge pulses, and hundreds."
        },
        {
            "name": "Yoga Flow",
            "body_part": "Core",
            "equipment": "Yoga Mat",
            "difficulty": "Beginner",
            "instructions": "Perform sun salutations, cat-cow stretches, and cobra pose.",
            "duration": "5 minutes"
        }
    ]

    return jsonify(exercises)

if __name__ == '__main__':
    app.run(debug=True)