# == Schema Information
#
# Table name: promotion_definitions
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  discount_type        :string
#  value                :bigint
#  promotion_state      :string           default("active")
#  promotion_type       :string
#  promotion_attributes :string
#  conditions           :string           default("true")
#  organization_id      :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted_at           :datetime
#  code                 :string
#  expiration_date      :date
#

require 'test_helper'

class PromotionDefinitionTest < ActiveSupport::TestCase
  def setup
    @promotion_definition = FactoryBot.build(:promotion_definition,
                                              promotion_attributes: 'total', conditions: 'total > 10')
  end

  test 'with valid attributes validation succeeds' do
    assert @promotion_definition.valid?
  end

  # discount_type test

  test 'with percentage discount_type validation succeeds' do
    @promotion_definition.discount_type = 'percentage'
    assert @promotion_definition.valid?
  end

  test 'with value discount_type validation succeeds' do
    @promotion_definition.discount_type = 'value'
    assert @promotion_definition.valid?
  end

  test 'with blank discount_type validation fails' do
    @promotion_definition.discount_type = ''
    assert_not @promotion_definition.valid?
  end

  test 'with invalid discount_type validation fails' do
    @promotion_definition.discount_type = 'number'
    assert_not @promotion_definition.valid?
  end

  # value for percentage test

  test 'with value of less than 0 for percentage validation fails' do
    @promotion_definition.discount_type = 'percentage'
    @promotion_definition.value = -1
    assert_not @promotion_definition.valid?
  end

  test 'with value of 0 for percentage validation succeeds' do
    @promotion_definition.discount_type = 'percentage'
    @promotion_definition.value = 0
    assert @promotion_definition.valid?
  end

  test 'with value of 100 for percentage validation succeeds' do
    @promotion_definition.discount_type = 'percentage'
    @promotion_definition.value = 100
    assert @promotion_definition.valid?
  end

  test 'with value of more than 100 for percentage validation fails' do
    @promotion_definition.discount_type = 'percentage'
    @promotion_definition.value = 101
    assert_not @promotion_definition.valid?
  end

  # value for value test

  test 'with value of less than 0 for value validation fails' do
    @promotion_definition.discount_type = 'value'
    @promotion_definition.value = -1
    assert_not @promotion_definition.valid?
  end

  test 'with value of 0 for value validation succeeds' do
    @promotion_definition.discount_type = 'value'
    @promotion_definition.value = 0
    assert @promotion_definition.valid?
  end

  test 'with value of 100 for value validation succeeds' do
    @promotion_definition.discount_type = 'value'
    @promotion_definition.value = 100
    assert @promotion_definition.valid?
  end

  test 'with value of more than 100 for value validation succeeds' do
    @promotion_definition.discount_type = 'value'
    @promotion_definition.value = 101
    assert @promotion_definition.valid?
  end

  # promotion_state test

  test 'with promotion_state active validation succeeds' do
    @promotion_definition.promotion_state = 'active'
    assert @promotion_definition.valid?
  end

  test 'with promotion_state inactive validation succeeds' do
    @promotion_definition.promotion_state = 'inactive'
    assert @promotion_definition.valid?
  end

  test 'with promotion_state blank validation fails' do
    @promotion_definition.promotion_state = ''
    assert_not @promotion_definition.valid?
  end

  test 'with promotion_state different than active or inactive validation fails' do
    @promotion_definition.discount_type = 'number'
    assert_not @promotion_definition.valid?
  end

  # promotion_type test

  test 'with promotion_type coupon validation succeeds' do
    @promotion_definition.promotion_type = 'coupon'
    assert @promotion_definition.valid?
  end

  test 'with promotion_type discount validation succeeds' do
    @promotion_definition.promotion_type = 'discount'
    assert @promotion_definition.valid?
  end

  test 'with promotion_type blank validation fails' do
    @promotion_definition.promotion_type = ''
    assert_not @promotion_definition.valid?
  end

  # promotion_attributes test

  test 'with promotion_attributes blank validation succeeds' do
    @promotion_definition.promotion_attributes = ''
    assert @promotion_definition.valid?
  end

  test 'with promotion_attributes valid validation succeeds' do
    @promotion_definition.promotion_attributes = 'total'
    assert @promotion_definition.valid?
  end

  # conditions test

  test 'with conditions blank validation succeeds' do
    @promotion_definition.promotion_attributes = ''
    assert @promotion_definition.valid?
  end

  test 'with conditions valid validation succeeds' do
    @promotion_definition.conditions = 'total > 100'
    assert @promotion_definition.valid?
  end

  test 'with undefined conditions validation fails' do
    @promotion_definition.conditions = 'not_defined > 100'
    assert_not @promotion_definition.valid?
  end

  # by_state scope test

  test 'returns the promotion definitions filtered by the given state' do
    promotion_definition1 = FactoryBot.create(:promotion_definition, promotion_state: 'active')
    promotion_definition2 = FactoryBot.create(:promotion_definition, promotion_state: 'inactive')
    promotion_definition3 = FactoryBot.create(:promotion_definition, promotion_state: 'inactive')

    assert PromotionDefinition.by_state('inactive').pluck('id').include?(promotion_definition2.id)
    assert PromotionDefinition.by_state('inactive').pluck('id').include?(promotion_definition3.id)
    assert_not PromotionDefinition.by_state('inactive').pluck('id').include?(promotion_definition1.id)
  end

  # by_type scope test

  test 'returns the promotion definitions filtered by the given type' do
    promotion_definition1 = FactoryBot.create(:promotion_definition, promotion_type: 'value')
    promotion_definition2 = FactoryBot.create(:promotion_definition, promotion_type: 'percentage')
    promotion_definition3 = FactoryBot.create(:promotion_definition, promotion_type: 'percentage')

    assert PromotionDefinition.by_type('percentage').pluck('id').include?(promotion_definition2.id)
    assert PromotionDefinition.by_type('percentage').pluck('id').include?(promotion_definition3.id)
    assert_not PromotionDefinition.by_type('percentage').pluck('id').include?(promotion_definition1.id)
  end

  # by_name scope test

  test 'returns the promotion definitions filtered by the given name' do
    promotion_definition1 = FactoryBot.create(:promotion_definition, name: 'foo')
    promotion_definition2 = FactoryBot.create(:promotion_definition, name: 'bar')
    promotion_definition3 = FactoryBot.create(:promotion_definition, name: 'art')

    assert PromotionDefinition.by_name('ar').pluck('id').include?(promotion_definition2.id)
    assert PromotionDefinition.by_name('ar').pluck('id').include?(promotion_definition3.id)
    assert_not PromotionDefinition.by_name('ar').pluck('id').include?(promotion_definition1.id)
  end

  # by_code scope test

  test 'returns the promotion definitions filtered by the given code' do
    promotion_definition1 = FactoryBot.create(:promotion_definition, code: '121')
    promotion_definition2 = FactoryBot.create(:promotion_definition, code: '1234')
    promotion_definition3 = FactoryBot.create(:promotion_definition, code: '52377')

    assert PromotionDefinition.by_code('23').pluck('id').include?(promotion_definition2.id)
    assert PromotionDefinition.by_code('23').pluck('id').include?(promotion_definition3.id)
    assert_not PromotionDefinition.by_code('23').pluck('id').include?(promotion_definition1.id)
  end
end
