class AddVkLikedandFbLikedtoUsers < ActiveRecord::Migration
  def change
    add_column :users, :VKLiked, :boolean, :default => false
    add_column :users, :FBLiked, :boolean, :default => false
  end
end
