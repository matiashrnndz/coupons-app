class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[show index]
  before_action :authorize_user, only: %i[edit]
  before_action :authorize_admin, only: %i[invitation]

  def index
    @users = User.all.order('last_name')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    create_user_and_organization
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'User updated'
      redirect_to @user
    else
      flash.now[:error] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, alert: 'User deleted succesfully'
  end

  def invitation
  end

  def create_invitation
    receiver_email = params[:email]
    temp_password = Digest::MD5.hexdigest(receiver_email)[0, 6]
    @user = User.new(first_name: 'temp', last_name: 'temp', password: temp_password,
                     organization: current_user.organization, email: receiver_email)
    if @user.save
      UserMailer.with(sender: current_user, receiver: @user,
                      pass: temp_password).invitation_email.deliver_later
      flash[:success] = 'invitation sent'
    else
      flash[:error] = @user.errors.full_messages
    end
    render :invitation
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

  def create_user_and_organization
    ActiveRecord::Base.transaction do
      organization = Organization.new(name: params[:organization_name], admin: @user)
      organization.save!
      assing_organization_to_user(organization)
      organization.save!
      flash[:success] = 'User created'
      redirect_to @user
    rescue ActiveRecord::RecordInvalid
      if organization
        organization.errors.full_messages.each do |message|
          @user.errors[:base] << message
        end
      end
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  def assing_organization_to_user(organization)
    @user.organization = organization
    @user.save!
  end
end
