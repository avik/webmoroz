class ChangeMarkInUsers < ActiveRecord::Migration
  def change
    change_column :users, :mark, :integer, :default => 1
  end
end
