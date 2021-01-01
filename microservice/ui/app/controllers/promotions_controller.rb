class PromotionsController < ApplicationController
  def new
    response = @request_service.get_request('get',"/promotion_definitions/#{params[:promotion_definition_id]}/promotions/new", {}, session['token'])
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

  def create
    request_params = { quantity: params[:quantity], uses: params[:uses], expiration_date: params[:expiration_date] }
    response = @request_service.get_request('post',"/promotion_definitions/#{params[:promotion_definition_id]}/promotions", request_params, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end

      flash.now[:success] = 'Generating coupons...'
      render json: { success: true }, status: :ok
    end
  end

  def index
    response = @request_service.get_request('get',"/promotion_definitions/#{params[:promotion_definition_id]}/promotions", {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @promo_definition = response['parent']
      @promotions = response['data']
    end
  end
end
