class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :nickname
      t.string :provider
      t.string :url
      t.date :bdate
      t.string :zipcode
      t.string :address

      t.timestamps
    end
  end
end
