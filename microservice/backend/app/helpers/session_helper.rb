module SessionHelper
  def sign_in(user)
    role = user.role
    new_token = JwtService.encode(user_id: user.id, organization_id: user.organization_id, role: role)
    render json: { token: new_token, user_id: user.id, role: role, organization_id: user.organization_id }, status: :ok
  end

  def current_user(user_id)
    User.find_by(id: user_id)
  end

  def current_user_is_user(current_user_id, user_id)
    current_user(current_user_id) && current_user_id.to_s == user_id
  end

  def current_user_is_admin
    current_user && current_user.id == current_tenant.admin_id
  end
end
