class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_user
  def index
    @users = User.all
    @presents = Present.all
  end

private
  def admin_user
    unless current_user.admin
      flash[:error] = "Access Denied"
      redirect_to root_url
    end
  end
end
