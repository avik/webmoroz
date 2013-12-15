class DashboardController < ApplicationController
  before_filter :validate_user
  def index
    @presents = Present.all
    @senders = @presents.where(:sender_id => current_user, :status => 0)
    @recipients = @presents.where(:recipient_id => current_user, :status => 0)
  end

  private

  def validate_user
    if current_user.username.blank? or current_user.email.blank? or current_user.zipcode.blank? or current_user.address.blank?
      current_user.update_attribute :activ, false
      unless current_user.admin
        respond_to do |format|
          format.html {
            flash[:error] = t('views.dashboard.activate_err') 
            return redirect_to edit_user_registration_path
          }
        end
      end
    else
      unless current_user.activ
        cookies[:first_time] = 1
        UserMailer.welcome_email(current_user.id).deliver
      end
      current_user.update_attribute :activ, true
    end
  end
end
