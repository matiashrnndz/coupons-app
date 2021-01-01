module SessionHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_user_is_user(user_id)
    current_user && current_user.id.to_s == user_id
  end

  def current_user_is_admin
    current_user && current_user.id == current_tenant.admin_id
  end
end
