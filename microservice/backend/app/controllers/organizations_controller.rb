class OrganizationsController < ApplicationController
  before_action :unauthorize_financer, only: %i[index]

  def index
    organization = current_tenant
    if organization
      render_record(Organization, organization)
    else
      render_not_found(Organization)
    end
  end
end
