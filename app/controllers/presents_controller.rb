class PresentsController < ApplicationController
  around_filter :catch_not_found
  before_filter :find_present, :only => [:close, :destroy]
  before_filter :check_free_presents, :only => [:new]

  def new
    @present = Present.new()
    user_id = current_user.id
    
    ignored_ids = Present.where("sender_id = ?",user_id).pluck(:recipient_id)
    ignored_ids.push(user_id)
    recipient = User.where("id NOT IN (?) AND activ = ? AND mark > ?",ignored_ids,true,0).order(:mark).reverse_order.first!
    #recipient.decrement!(:mark)
    @present.code = (0...5).map { (65 + rand(26)).chr }.join
    @present.recipient_id = recipient.id
    @present.sender_id = user_id
    @present.save
    respond_to do |format|
      format.html {
        flash[:success] = t('views.present.success')
        return redirect_to :back
      }
    end
  end

  def close
    @present = Present.find(params[:id])
    if (@present[:code].to_s != params[:code].to_s)
      respond_to do |format|
        format.html {
          flash[:error] = t('views.present.code_error')
          return redirect_to :back
        }
      end
    end
    sender = User.find(@present.sender_id)
    sender.increment!(:mark)
    @present[:closed_at] = Time.now
    @present[:status] = 1
    @present.save
    redirect_to :back
  end

  def destroy
    @present.destroy
    redirect_to :back
  end

private
  def check_free_presents
    num_of_send = Present.where("sender_id = ? AND status =?",current_user.id,0).count
    if (num_of_send > 2)
      respond_to do |format|
        format.html {
          flash[:warning] = t('views.present.max_presents')
          return redirect_to :back
        }
      end
    end
  end

  def find_present
    @present = Present.find(params[:id])
  end

  def catch_not_found
    yield
    rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html {
        flash[:error] = t('views.present.recepients_error')
        redirect_to root_url
      }
    end
  end
end
