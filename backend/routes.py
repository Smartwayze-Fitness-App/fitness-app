from flask import Blueprint
from controllers import (
    get_prebuilt_plans,
    create_custom_workout,
    get_categories,
    get_plans_by_category,
    track_progress,
    get_user_progress,
    register_user,
    login_user
)

bp = Blueprint('api', __name__)

bp.route('/users/register',methods=['POST'])(register_user)
bp.route('/users/login',methods=['POST'])(login_user)
bp.route('/workouts', methods=['GET'])(get_prebuilt_plans)
bp.route('/workouts', methods=['POST'])(create_custom_workout)
bp.route('/api/workouts/categories', methods=['GET'])(get_categories)
bp.route('/api/workouts/category/<category>', methods=['GET'])(get_plans_by_category)
bp.route('/progress', methods=['POST'])(track_progress)
bp.route('/api/progress/<int:user_id>', methods=['GET'])(get_user_progress)
