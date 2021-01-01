class ApplicationController < ActionController::Base
  include SessionHelper
  include ApplicationHelper

  protect_from_forgery with: :null_session
  set_current_tenant_through_filter
  before_action :set_organization
  before_action :set_tracer
  after_action :close_tracer

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      JwtService.decode(header)
    rescue JWT::DecodeError => e
      false
    end
  end

  def authenticate_user
    header = authorize_request
    render_unauthorized unless header && current_user(header[:user_id]) and return
  end

  def authorize_user
    header = authorize_request
    render_unauthorized(["You don't have permission to perform this action"]) unless current_user_is_user(header[:user_id], params[:id]) and return
  end

  def authenticate_or_authorize_user
    header = authorize_request
    if header && header[:role] == 'financer'
      authorize_user
    else
      authenticate_user
    end
  end

  def authorize_admin
    header = authorize_request
    render_unauthorized(["You don't have permission to perform this action"]) unless header && header[:role] == 'admin' and return
  end

  def unauthorize_financer
    header = authorize_request
    render_unauthorized(["You don't have permission to perform this action"]) unless header && header[:role] != 'financer' and return
  end

  def set_organization
    header = request.headers['Authorization']
    header = authorize_request if header
    set_organization_from_user if header && current_user(header[:user_id])
  end

  def set_organization_from_user
    header = authorize_request
    current_organization = Organization.find(current_user(header[:user_id]).organization_id)
    set_current_tenant(current_organization)
  end

  protected

  def set_tracer
    @span = LightStep.start_span("#{request.method} #{request.path}")
  end

  def close_tracer
    @span.finish
  end

  def render_record(klass, record, options = {})
    render json: "#{klass.model_name}Serializer".constantize.new(record, options).serializable_hash, status: :ok and return
  end

  def render_record_collection(klass, records, options = {})
    json_collection = "#{klass.model_name}Serializer".constantize.new(records, options).serializable_hash
    json_collection[:parent] = options[:parent] if options[:parent]
    render json: json_collection, status: :ok and return
  end

  def render_not_found(klass)
    render_errors(["#{klass.model_name.human} not found."], :not_found)
  end

  def render_unprocessable(errors)
    render_errors(errors, :unprocessable_entity)
  end

  def render_unauthorized(errors = ['You need to sign in to continue.'])
    render_errors(errors, :unauthorized)
  end

  def render_errors(errors, status_code)
    render json: { errors: errors }, status: status_code and return
  end
end
