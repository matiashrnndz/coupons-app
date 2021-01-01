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
end
