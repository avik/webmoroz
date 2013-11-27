class AddAdminAndActivateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :activ, :boolean, :default => false
  end
end
