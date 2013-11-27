class CreatePresents < ActiveRecord::Migration
  def change
    create_table :presents do |t|
      t.string :code, :unique => true
      t.integer :sender_id
      t.integer :recipient_id
      #t.references :sender
      #t.references :recipient
      t.integer :status, :default => 0
      t.datetime :closed_at

      t.timestamps
    end
  end
end
