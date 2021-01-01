class SessionController < ApplicationController
  def signin
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      sign_in(@user)
      flash[:success] = 'Welcome'
    else
      flash[:error] = 'Invalid credentials, try again.'
    end
    redirect_to root_path
  end

  def signout
    sign_out
    redirect_to root_path
  end
end
