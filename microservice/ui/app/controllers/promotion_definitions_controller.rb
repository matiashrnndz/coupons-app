class PromotionDefinitionsController < ApplicationController
  before_action :set_promotion_definition, only: %i[show edit update destroy]

  def show
  end

  def index
    request_params = { by_state: params[:by_state], by_type: params[:by_type], by_name: params[:by_name], by_code: params[:by_code] }
    response = @request_service.get_request('get','/promotion_definitions', request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      @promo_definitions = response['data']
    end
  end

  def new
    response = @request_service.get_request('get','/promotion_definitions/new', {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
    end
  end

  def create
    request_params = {
      name: params[:promotion_definition][:name],
      discount_type: params[:promotion_definition][:discount_type],
      promotion_type: params[:promotion_definition][:promotion_type],
      value: params[:promotion_definition][:value],
      promotion_attributes: params[:promotion_definition][:promotion_attributes],
      conditions: params[:promotion_definition][:conditions],
      expiration_date: params[:promotion_definition][:expiration_date]
    }
    response = @request_service.get_request('post','/promotion_definitions', request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash.now[:error] = response['errors']
        render :new
      else
        flash[:success] = 'Promotion definition created'
        redirect_to promotion_definition_path(response['data']['id'])
      end
    end
  end

  def edit
    response = @request_service.get_request('get',"/promotion_definitions/#{params[:id]}/edit", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @promo_definition = response['data']
    end
  end

  def update
    request_params = {
      name: params[:promotion_definition][:name],
      promotion_state: params[:promotion_definition][:promotion_state],
    }
    response = @request_service.get_request('patch',"/promotion_definitions/#{params[:id]}", request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash.now[:error] = response['errors']
        render :edit
      else
        flash[:success] = 'Promotion definition updated'
        redirect_to promotion_definition_path(params[:id])
      end
    end
  end

  def destroy
    response = @request_service.get_request('delete',"/promotion_definitions/#{params[:id]}", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
      else
        flash[:success] = 'Promotion definition deleted'
      end
      redirect_to root_path
    end
  end
  
  def report
    response = @request_service.get_request('get', "/promotion_definitions/#{params[:id]}/report", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response[:connection_error]
        render file: "#{Rails.root}/public/500", layout: false, status: :error
      else
        if response['errors'] && response['errors'].count > 0
          flash[:error] = response['errors']
          redirect_to root_path
        else
          service_response = @request_service.get_request('get', "/promo_stats/#{params[:id]}/summary", {}, response['token'])
          if service_response[:connection_error]
            render file: "#{Rails.root}/public/500", layout: false, status: :error
          else
            if service_response[:errors] == 'PromoId does not exists.'
              @report = {}
              @report['total_calls'] = 0
              @report['successful'] = 0
              @report['unsuccessful'] = 0
              @report['successful_ratio'] = 0
              @report['average_response_time'] = 0
              @report['total_spent'] = 0
            else
              @report = service_response
              @report['promotion_name'] = response['promotion_name']
            end
          end
        end
      end
    end
  end

  def demographic_report
    response = @request_service.get_request('get', "/promotion_definitions/#{params[:id]}/demographic_report", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      else
        @promotion_id = response['promotion_id']
      end
    end
  end

  def demographic_report_view
    request_params = {
      country: params[:demo_report][:country],
      city: params[:demo_report][:city],
      age: params[:demo_report][:age]
    }
    response = @request_service.get_request('get', "/promotion_definitions/#{params[:id]}/demographic_report_view", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      else
        service_response = @request_service.get_request('get', "/promo_stats/#{params[:id]}/demographic", request_params, response['token'])
        if service_response[:connection_error]
          render file: "#{Rails.root}/public/500", layout: false, status: :error
        else
          if service_response[:errors] == 'PromoId does not exists.'
            @count = 0
          else
            @count = service_response['count']
          end
          @promotion_id = params[:id]
          render :demographic_report
        end
      end
    end
  end

  private

  def set_promotion_definition
    response = @request_service.get_request('get', "/promotion_definitions/#{params[:id]}", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @promo_definition = response['data']
    end
  end
end
