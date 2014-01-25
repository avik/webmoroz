class DashboardController < ApplicationController
  before_filter :validate_user
  def index
    @presents = Present.all
    @senders = @presents.where(:sender_id => current_user, :status => 0)
    @recipients = @presents.where(:recipient_id => current_user, :status => 0)
  end

  private

  def validate_user
    msg = Array.new
    msg.push(t('views.dashboard.errors.username')) if current_user.username.blank?
    msg.push(t('views.dashboard.errors.zipcode')) if current_user.zipcode.blank?
    msg.push(t('views.dashboard.errors.address')) if current_user.address.blank?
    msg.push(t('views.dashboard.errors.bdate')) if current_user.bdate.blank?
    if msg.empty? 
      unless current_user.activ
        cookies[:first_time] = 1 
        UserMailer.welcome_email(current_user.id).deliver
        current_user.update_attribute :activ, true
      end
    else
      current_user.update_attribute :activ, false
      flash[:error] = msg
      redirect_to edit_user_registration_path
    end
  end
end
