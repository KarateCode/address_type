class Addresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :type, :limit => 25
      #t.integer :user_id
      t.string :line1
      t.string :line2
      t.string :city
      t.string :country
      t.string :state
      t.string :zip
    end
  end

  def self.down
    drop_table :addresses
  end
end
