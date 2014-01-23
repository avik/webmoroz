require "spec_helper"
require "user"
describe User do
  it "is email invalid" do
    User.create(:email => 'incorrect_mail', :password => '123456').should_not be_valid
  end
  it "is email valid" do
    User.create(:email => 'mail@mail.com', :password => '123456').should be_valid
  end
  it "is duplicate email" do
    User.create(:username => 'Dim', :email => 'mail@mail.com')
    User.create(:username => 'Dim', :email => 'mail@mail.com').should_not be_valid
  end
end
