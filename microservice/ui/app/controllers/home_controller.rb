class HomeController < ApplicationController
  def index
    @promo_definitions = current_tenant.promotion_definitions if current_tenant
  end
end
