class SessionController < ApplicationController
  def signin
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      sign_in(@user)
    else
      render json: { errors: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
