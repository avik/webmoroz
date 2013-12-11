require "spec_helper"
require "user"
describe User do
  it "is named Dim" do
    user = User.create(:username => 'Dim')
    user.username.should == 'Dim'
  end
end
