class UsersController < ApplicationController
  before_action :authenticate_or_authorize_user, only: %i[show]
  before_action :authorize_user, only: %i[edit update]
  before_action :authorize_admin, only: %i[invitation create_invitation]

  def create
    @user = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], role: 'admin')
    create_user_and_organization
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render_record(User, @user)
    else
      render_not_found(User)
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    if @user
      render_record(User, @user)
    else
      render_not_found(User)
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user
      @user.update!(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      render_record(User, @user)
    else
      render_not_found(User)
    end
  rescue ActiveRecord::RecordInvalid => exception
    render_unprocessable(exception.record.errors.full_messages)
  end

  def invitation
    render json: { success: true }, status: :ok
  end

  def create_invitation
    receiver_email = params[:email]
    role = params[:role]
    temp_password = Digest::MD5.hexdigest(receiver_email)[0, 6]
    @user = User.new(first_name: 'temp', last_name: 'temp', password: temp_password,
                     organization: current_tenant, email: receiver_email, role: role)
    @user.save!
    UserMailer.with(sender: current_tenant.admin, receiver: @user,
                    pass: temp_password).invitation_email.deliver_later
    render_record(User, @user)
    
    rescue ActiveRecord::RecordInvalid => exception
      render_unprocessable(exception.record.errors.full_messages)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

  def create_user_and_organization
    ActiveRecord::Base.transaction do
      organization = Organization.new(name: params[:organization_name])
      organization.save!
      @user.organization = organization
      @user.save!
      organization.save!
      
      render_record(User, @user)
    rescue ActiveRecord::RecordInvalid => exception
      if organization
        organization.errors.full_messages.each do |message|
          @user.errors[:base] << message
        end
      end
      render_unprocessable(exception.record.errors.full_messages)
    end
  end
end
