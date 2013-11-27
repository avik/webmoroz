class WelcomeController < ApplicationController
  #before_filter :authenticate_user!
  #before_filter :validate_user
  def index
  end

  private

  def validate_user
    val_msg = ""
    val_status = true
    unless current_user.zipcode.presence
      flash[:error] = "You must enter Zipcode"
      val_status = false
    end
    unless current_user.address.presence
      val_msg += "You must enter Address\n"
      val_status = false
    end
    unless current_user.bdate.presence
      val_msg += "You must enter Birthday\n"
      val_status = false
    end
    unless val_status
      flash[:error] = val_msg
      redirect_to edit_user_registration_path
    end
  end
end
