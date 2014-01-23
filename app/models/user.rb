class User < ActiveRecord::Base
  validates :email, :email => true
  before_destroy :delete_presents
#  belongs_to :presents, dependent: :destroy, :foreign_key => 'sender_id'
#  has_many :presents, dependent: :destroy, :foreign_key => 'sender_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username, :point, :bdate, :zipcode, :address, :mark

  def self.find_for_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else
      date = Date.today
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Facebook, :username => access_token.extra.raw_info.name, :nickname => access_token.extra.raw_info.username, :email => access_token.extra.raw_info.email, :bdate => date, :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      unless access_token.extra.raw_info.bdate.nil?
        date = Date.parse(access_token.extra.raw_info.bdate)
      else
        date = Date.today
      end
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => access_token.extra.raw_info.screen_name+'@vk.com', :bdate => date, :password => Devise.friendly_token[0,20])
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
