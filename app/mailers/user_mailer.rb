class UserMailer < ApplicationMailer
  default from: "em4728644@gmail.com"

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'welcome to our app')
  end
end
