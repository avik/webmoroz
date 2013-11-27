class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_user
  def index
    @users = User.all
    @presents = Present.all
  end

  def create_mass_users
    users_list = params[:userslist]
    users_arr = users_list.to_s.split(/\n/)
    users_arr.each do | user_string |
      user_arr = user_string.to_s.split(/;/)
      mail = (0...5).map { (65 + rand(26)).chr }.join
      User.create!(:username => user_arr[1], :email => mail+'@example.com', :password => '12345678', :zipcode => user_arr[2], :address => user_arr[3])
    end
    #User.create!(:username => users_list, :email => 'text@example.com', :password => '12345678')
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Users were successfully created.' }
    end
  end

  private

  def admin_user
    unless current_user.admin
      flash[:error] = "Access Denied"
      redirect_to root_url
    end
  end
end
