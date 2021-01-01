class OrganizationsController < ApplicationController

  def index
    response = @request_service.get_request('get','/organizations', {}, session['token'])
    if response[:connection_error]
      render file: "#{Rails.root}/public/500", layout: false, status: :error
    else
      if response['errors'] && response['errors'].count > 0
        flash[:error] = response['errors']
        redirect_to root_path
      end
      @organization = response['data']
    end
  end
end
