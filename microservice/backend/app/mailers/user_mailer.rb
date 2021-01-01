class UserMailer < ApplicationMailer
  # default from: 'notifications@example.com'

  def invitation_email
    @sender = params[:sender]
    @organization = @sender.organization
    @pass = params[:pass]
    mail = params[:receiver].email
    @url = edit_user_url(params[:receiver])
    mail(to: mail, from: 'coupons.app.ort@gmail.com', subject: 'Invite to organization')
  end

  def expiration_reminder_email
    @expired_promotions = params[:expired_promotions]
    @soon_expired_promotions = params[:soon_expired_promotions]
    receivers = params[:emails]
    mail(to: receivers, from: 'coupons.app.ort@gmail.com', subject: 'Expiration reminder')
  end
end
