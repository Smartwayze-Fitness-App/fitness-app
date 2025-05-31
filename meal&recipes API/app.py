from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/meal-plans', methods=['GET'])
def get_meal_plans():
    data = {
        "Morning": [
            {
                "name": "Oatmeal with Berries",
                "calories": 300,
                "serving": "1 Bowl",
                "protein": "10g",
                "carbs": "40g",
                "fats": "5g",
                "type": "Vegetarian"
            },
            {
                "name": "Boiled Eggs & Toast",
                "calories": 250,
                "serving": "2 Eggs & 1 Slice Toast",
                "protein": "12g",
                "carbs": "20g",
                "fats": "10g",
                "type": "High Protein"
            },
            {
                "name": "Greek Yogurt with Honey",
                "calories": 180,
                "serving": "1 Cup",
                "protein": "15g",
                "carbs": "12g",
                "fats": "4g",
                "type": "Vegetarian"
            }
        ],
        "Afternoon": [
            {
                "name": "Grilled Chicken Salad",
                "calories": 350,
                "serving": "1 Plate",
                "protein": "25g",
                "carbs": "15g",
                "fats": "10g",
                "type": "Keto"
            },
            {
                "name": "Quinoa & Veggies",
                "calories": 300,
                "serving": "1 Bowl",
                "protein": "12g",
                "carbs": "35g",
                "fats": "8g",
                "type": "Vegetarian"
            },
            {
                "name": "Tuna Wrap",
                "calories": 400,
                "serving": "1 Wrap",
                "protein": "20g",
                "carbs": "30g",
                "fats": "15g",
                "type": "High Protein"
            }
        ],
        "Evening": [
            {
                "name": "Stir Fry Veggies with Tofu",
                "calories": 280,
                "serving": "1 Bowl",
                "protein": "18g",
                "carbs": "20g",
                "fats": "9g",
                "type": "Vegetarian"
            },
            {
                "name": "Grilled Salmon with Asparagus",
                "calories": 450,
                "serving": "1 Plate",
                "protein": "30g",
                "carbs": "10g",
                "fats": "25g",
                "type": "Keto"
            },
            {
                "name": "Chicken Soup",
                "calories": 200,
                "serving": "1 Bowl",
                "protein": "18g",
                "carbs": "8g",
                "fats": "7g",
                "type": "High Protein"
            }
        ]
    }
    return jsonify(data)

@app.route('/recipes', methods=['GET'])
def get_recipes():
    recipes = [
        {
            "name": "Oatmeal with Berries",
            "ingredients": ["Oats", "Milk", "Berries", "Honey"],
            "instructions": "Cook oats in milk, top with berries and honey."
        },
        {
            "name": "Boiled Eggs & Toast",
            "ingredients": ["Eggs", "Bread", "Salt"],
            "instructions": "Boil eggs, toast the bread, and serve with salt."
        },
        {
            "name": "Grilled Chicken Salad",
            "ingredients": ["Chicken breast", "Lettuce", "Tomato", "Olive oil"],
            "instructions": "Grill chicken, mix with vegetables and dressing."
        },
        {
            "name": "Stir Fry Veggies with Tofu",
            "ingredients": ["Tofu", "Broccoli", "Bell pepper", "Soy sauce"],
            "instructions": "Stir fry veggies and tofu in soy sauce."
        }
    ]
    return jsonify(recipes)

if __name__ == '__main__':
    app.run(debug=True)
