class UsersController < ApplicationController

  def new
  end

  def create
    request_params = {
      first_name: params[:user][:first_name],
      last_name: params[:user][:last_name],
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      organization_name: params[:organization_name]
    }
    response = @request_service.get_request('post','/users', request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash.now[:error] = response['errors']
        render :new
      else
        flash[:success] = 'User created'
        redirect_to root_path
      end
    end
  end

  def show
    response = @request_service.get_request('get',"/users/#{params[:id]}", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @user = response['data']
    end
  end

  def edit
    response = @request_service.get_request('get',"/users/#{params[:id]}/edit", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @user = response['data']
    end
  end

  def update
    request_params = {
      first_name: params[:user][:first_name],
      last_name: params[:user][:last_name],
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      organization_name: params[:organization_name]
    }
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      response = @request_service.get_request('patch',"/users/#{params[:id]}", request_params, session['token'])
      if response['errors'] && response['errors'].count > 0
        flash.now[:error] = response['errors']
        render :edit
      else
        flash[:success] = 'User updated'
        redirect_to user_path(params[:id])
      end
    end
  end

  def invitation
    response = @request_service.get_request('get','/invitation/form', {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
    end
  end

  def create_invitation
    request_params = { email: params[:email], role: params[:role] }
    response = @request_service.get_request('post','/invitation/link', request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
      else
        flash[:success] = 'Invitation send'
      end
      redirect_to invitation_form_path
    end
  end
end
