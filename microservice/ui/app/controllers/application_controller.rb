class ApplicationController < ActionController::Base
  include SessionHelper
  include ApplicationHelper

  protect_from_forgery with: :null_session

  before_action :set_request_service

  protected

  def set_request_service
    @request_service = RequestService.new
  end

  def render_record(klass, record, options = {})
    render json: "#{klass.model_name}Serializer".constantize.new(record, options).serializable_hash, status: :ok and return
  end

  def render_record_collection(klass, records, options = {})
    render json: "#{klass.model_name}Serializer".constantize.new(records, options).serializable_hash, status: :ok and return
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
