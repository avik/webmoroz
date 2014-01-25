class User < ActiveRecord::Base
  validates :email, :email => true
  before_destroy :delete_presents
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :omniauthable
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :nickname, :provider, :url,
                  :username, :point, :bdate, :zipcode,
                  :address, :mark

  def self.find_for_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else
      User.create!(
        :provider => access_token.provider, 
        :url => access_token.info.urls.Facebook,
        :username => access_token.extra.raw_info.name, 
        :nickname => access_token.extra.raw_info.username,
        :email => access_token.extra.raw_info.email, 
        :bdate => Date.today,
        :password => Devise.friendly_token[0,20]
      )
    end
  end

  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      date = Date.parse(access_token.extra.raw_info.bdate) rescue nil || Date.today
      User.create!(
        :provider => access_token.provider,
        :url      => access_token.info.urls.Vkontakte,
        :username => access_token.info.name,
        :nickname => access_token.extra.raw_info.domain,
        :email    => access_token.extra.raw_info.screen_name+'@vk.com',
        :bdate    => date,
        :password => Devise.friendly_token[0,20]
      )
    end
  end

  def age
    dob = self.bdate
    now = Time.now.utc.to_date
    begin
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    rescue
    end
  end

private
  def delete_presents
    Present.where(:sender_id => self.id).destroy_all
    Present.where(:recipient_id => self.id).destroy_all
  end
end
