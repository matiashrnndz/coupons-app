class ApplicationController < ActionController::Base
  include SessionHelper
  include ApplicationHelper

  set_current_tenant_through_filter
  before_action :set_organization

  def authenticate_user
    redirect_to root_path unless current_user
  end

  def authorize_user
    redirect_to root_path unless current_user_is_user(params[:id])
  end

  def authorize_admin
    redirect_to root_path unless current_user_is_admin
  end

  def set_organization
    set_organization_from_user if current_user
  end

  def set_organization_from_user
    current_organization = Organization.find(current_user.organization_id)
    set_current_tenant(current_organization)
  end
end
