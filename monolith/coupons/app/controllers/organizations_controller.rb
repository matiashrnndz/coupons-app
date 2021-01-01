class OrganizationsController < ApplicationController
  before_action :authenticate_user, only: %i[show]

  def show
    @organization = current_tenant
  end
end
