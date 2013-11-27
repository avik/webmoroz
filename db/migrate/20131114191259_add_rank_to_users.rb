class AddRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mark, :integer, :default => 3
  end
end
