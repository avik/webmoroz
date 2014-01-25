class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_active, :toggle_admin]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    unless current_user.admin
      flash[:error] = "Access Denied"
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :back, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def mark_increase_social
    social = params[:social]
    liked = case social
      when 'vk' then current_user.VKLiked ^= true
      when 'fb' then current_user.FBLiked ^= true
      else false
    end
    if liked
      current_user.mark += 1
      current_user.save
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => current_user.mark }
    end
  end

  def toggle_active
    @user.toggle!(:activ)
    redirect_to :back
  end

  def toggle_admin
    @user.toggle!(:admin)
    redirect_to :back
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:username, :nickname, :provider, :url, :zipcode, :address, :mark)
    end
end
