module SessionHelper
  def sign_in(token, user_id, role, organization_id)
    session[:token] = token
    session[:user_id] = user_id
    session[:role] = role
    session[:organization_id] = organization_id
  end

  def sign_out
    session[:token] = nil
    session[:user_id] = nil
    session[:role] = nil
    session[:organization_id] = nil
  end

  def current_user
    if session[:user_id]
      response = @request_service.get_request('get',"/users/#{session[:user_id]}", {}, session['token'])
      if response[:connection_error]
        render file: "#{Rails.root}/public/500", layout: false, status: :error
      end
      return response
    else
      return nil
    end
  end

  def current_user_is_user(user_id)
    current_user && current_user['data']['id'].to_s == user_id
  end

  def current_user_is_admin
    session[:role] == 'admin'
  end

  def current_user_is_financer
    session[:role] == 'financer'
  end
end
