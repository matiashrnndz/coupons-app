# == Schema Information
#
# Table name: promotions
#
#  id                      :bigint           not null, primary key
#  promotion_definition_id :bigint
#  code                    :string
#  used                    :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  def setup
    @promotion = FactoryBot.build(:promotion)
  end

  test 'with valid attributes validation succeeds' do
    assert @promotion.valid?
  end

  # code tests

  test 'with atleast 1 character code validation succeeds' do
    @promotion.code = '1'
    assert @promotion.valid?
  end

  # test 'with blank code validation fails' do
  #   @promotion.code = ''
  #   assert !@promotion.valid?
  # end

  # used tests

  test 'with true used validation succeeds' do
    @promotion.used = true
    assert @promotion.valid?
  end

  test 'with false used validation succeeds' do
    @promotion.used = false
    assert @promotion.valid?
  end

  # promotion_definition tests

  test 'with nil promotion_definition validation fails' do
    @promotion.promotion_definition = nil
    assert_not @promotion.valid?
  end
end
