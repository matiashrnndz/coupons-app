class SessionController < ApplicationController
  def signin
    request_params = { email: params[:email], password: params[:password] }
    response = @request_service.get_request('post','/sessions/signin', request_params)
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['token']
        sign_in(response['token'], response['user_id'], response['role'], response['organization_id'])
        redirect_to root_path
      else
        flash[:error] = response['errors']
        redirect_to root_path
      end
    end
  end

  def signout
    sign_out
    redirect_to root_path
  end
end
