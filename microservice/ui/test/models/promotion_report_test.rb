# == Schema Information
#
# Table name: promotion_reports
#
#  id                      :bigint           not null, primary key
#  promotion_definition_id :bigint
#  successful              :boolean
#  response_time           :bigint
#  spent_amount            :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class PromotionReportTest < ActiveSupport::TestCase
  def setup
    @report = FactoryBot.build(:promotion_report)
  end

  test 'with valid attributes validation succeeds' do
    assert @report.valid?
  end

  # response_time tests

  test 'with no response time validation fails' do
    @report.response_time = nil
    assert_not @report.valid?
  end

  # spent_amount tests

  test 'with no spent_amount validation fails' do
    @report.spent_amount = nil
    assert_not @report.valid?
  end

  # promotion_definition tests

  test 'with nil promotion_definition validation fails' do
    @report.promotion_definition = nil
    assert_not @report.valid?
  end

  # for_promotion scope tests

  test 'returns the reports related to the given promotion_definition' do
    promotion_definition = FactoryBot.create(:promotion_definition)
    report1 = FactoryBot.create(:promotion_report, promotion_definition: promotion_definition)
    FactoryBot.create(:promotion_report)
    report3 = FactoryBot.create(:promotion_report, promotion_definition: promotion_definition)
    assert_equal(PromotionReport.for_promotion(promotion_definition).to_a, [report1, report3])
  end

  # positive scope tests

  test 'returns the reports with successful calls' do
    report1 = FactoryBot.create(:promotion_report, successful: true)
    FactoryBot.create(:promotion_report, successful: false)
    report3 = FactoryBot.create(:promotion_report, successful: true)
    assert_equal PromotionReport.positive.to_a, [report1, report3]
  end
end
