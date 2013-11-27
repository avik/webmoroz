# coding: utf-8
class PresentsController < ApplicationController
  around_filter :catch_not_found
  def new
    ignored_ids = Present.where("sender_id = ?",current_user.id).pluck(:recipient_id)
    ignored_ids.push(current_user.id)
    num_of_send = Present.where("sender_id = ? AND status =?",current_user.id,0).count
    if (num_of_send > 2)
      respond_to do |format|
        format.html {
          flash[:warning] = "Вы не можете добавить больше трех подарков. Дождитесь доставки"
          return redirect_to :back
        }
        format.json { render action: 'show', status: :created, location: @user }
      end
    end
    recipient = User.where("id NOT IN (?) AND activ = ? AND mark > ?",ignored_ids,true,0).order(:mark).reverse_order.first!
    code = (0...5).map { (65 + rand(26)).chr }.join
    recipient.decrement!(:mark)
    Present.create(:code => code, :sender_id => current_user.id, :recipient_id => recipient.id)
    respond_to do |format|
      format.html {
        flash[:success] = "Подарок успешно добавлен"
        return redirect_to :back
      }
      format.json { render action: 'show', status: :created, location: @user }
    end
  end
  def close
    @present = Present.find(params[:id])
    if (@present[:code].to_s != params[:code].to_s)
      respond_to do |format|
        format.html {
          flash[:error] = "Код введен неправильно"
          return redirect_to :back
        }
        format.json { render action: 'show', status: :created, location: @user }
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
    @present = Present.find(params[:id])
    @present.destroy
    redirect_to :back
  end

private
  def catch_not_found
    yield
    rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html {
        flash[:error] = "Нет свободных адресатов"
        redirect_to root_url
      }
      format.json { render action: 'show', status: :created, location: @user }
    end
  end
end
