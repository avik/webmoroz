class Present < ActiveRecord::Base
  before_destroy :return_mark
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"
  attr_accessible :code, :sender_id, :recipient_id, :status, :closed

  def self.create_present current_user
    code = (0...5).map { (65 + rand(26)).chr }.join
    Present.create(:code => code, :sender => current_user.id)
  end

  private

  def return_mark
    if (self.status == 0)
      recipient = User.find(self.recipient_id)
      recipient.increment!(:mark)
    end
  end

end
