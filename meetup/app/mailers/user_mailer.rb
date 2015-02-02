class UserMailer < ActionMailer::Base
  default from: "hello@happypeter.org"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome')
  end
end
