class UserMailer < ActionMailer::Base
  default :from => "\"WebMoroz\" <mail@webmoroz.com>"

  def welcome_email(id)
    @user = User.find(id)
    mail(to: @user.email, subject: 'Добро пожаловать, ВебМороз!')
  end
end
