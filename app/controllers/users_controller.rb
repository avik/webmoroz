class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless current_user.admin
      flash[:error] = "Access Denied"
      redirect_to root_url
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(current_user.id).deliver
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def mark_increase_social
    social = params[:social]
    liked = false
    if social == 'vk'
      unless current_user.VKLiked
        current_user.update_attribute :VKLiked, true
        current_user.increment!(:mark)
        liked = true
      end
    elsif social == 'fb'
      unless current_user.FBLiked
        current_user.update_attribute :FBLiked, true
        current_user.increment!(:mark)
        liked = true
      end
    end
    respond_to do |format|
      if liked
        format.html { redirect_to :back }
        format.json { render :json => current_user.mark }
      else
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    end
  end

  def toggle_active
    @user = User.find(params[:id])
    @user.toggle!(:activ)
    redirect_to :back
#    render :nothing => true
  end

  def toggle_admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    redirect_to :back
#    render :nothing => true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :nickname, :provider, :url, :zipcode, :address, :mark)
    end
end
