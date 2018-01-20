class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_mail.subject
  #
  def send_mail(user)
    @user = user
    @greeting = "Hi"

    mail to: user.email, subject:"Sample from Rails"
  end
end
