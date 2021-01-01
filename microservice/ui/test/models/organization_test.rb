# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  name       :string
#  admin_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = FactoryBot.create(:organization, name: 'ORT')
  end

  test 'with valid attributes validation succeeds' do
    assert @organization.valid?
  end

  # name test

  test 'with no name validations fails' do
    @organization.name = ''
    assert_not @organization.valid?
  end

  test 'with repeated name validations fails' do
    # @organization.save
    @organization2 = FactoryBot.build(:organization, name: 'ort')
    assert_not @organization2.valid?
  end

  # admin test

  test 'with no admin validation fails' do
    @organization.admin = nil
    assert_not @organization.valid?
  end
end
