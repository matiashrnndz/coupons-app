# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = FactoryBot.build(:user, organization: FactoryBot.build(:organization))
  end

  test 'with valid attributes validation succeeds' do
    assert @user.valid?
  end

  # first_name tests

  test 'with empty first_name validation fails' do
    @user.first_name = ''
    assert_not @user.valid?
  end

  test 'with a number in first_name validation fails' do
    @user.first_name = 'Juan5'
    assert_not @user.valid?
  end

  test 'with more than 20 characters in first_name validation fails' do
    @user.first_name = 'Perezperezperezperezz'
    assert_not @user.valid?
  end

  # last_name tests

  test 'with empty last_name validation fails' do
    @user.last_name = ''
    assert_not @user.valid?
  end

  test 'with a number in last_name validation fails' do
    @user.last_name = 'Perez5'
    assert_not @user.valid?
  end

  test 'with more than 20 characters in last_name validation fails' do
    @user.last_name = 'Perezperezperezperezz'
    assert_not @user.valid?
  end

  # email tests

  test 'with invalid email validation fails' do
    @user.email = 'joseperez'
    assert_not @user.valid?
  end

  test 'with valid email validation succeeds' do
    @user.email = 'jose@perez.com'
    assert @user.valid?
  end

  # password tests

  test 'with less than 6 characters password validation fails' do
    @user.password = '12345'
    assert_not @user.valid?
  end

  test 'with 6 characters password validation succeeds' do
    @user.password = '123456'
    assert @user.valid?
  end

  # organization tests

  test 'with no organization validation fails' do
    @user.organization = nil
    assert_not @user.valid?
  end
end
