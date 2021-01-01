require 'sidekiq-scheduler'

class PromotionReminderWorker
  include Sidekiq::Worker

  def perform
    Organization.all.includes(:users).includes(:promotion_definitions).each do |organization|
      user_mails = []
      expired_promotions = []
      soon_expired_promotions = []
      organization.users.each do |user|
        user_mails << user.email if user.role == 'admin'
      end

      organization.promotion_definitions.each do |promo|
        expired_promotions << promo.name if promo.expiration_date == Date.today
        soon_expired_promotions << promo.name if promo.expiration_date == Date.today + 1.days
      end
      if expired_promotions.count > 0 || soon_expired_promotions.count > 0
        UserMailer.with(emails: user_mails, expired_promotions: expired_promotions,
        soon_expired_promotions: soon_expired_promotions).expiration_reminder_email.deliver_now
      end
    end
  end
end