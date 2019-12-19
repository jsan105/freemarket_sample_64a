class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string  :name,         null: false
      t.string  :name2,         null: false
      t.string  :katakana,     null: false
      t.string  :katakana2,     null: false
      t.string  :postal_code,  null: false
      t.string  :prefucture,   null: false
      t.string  :city,         null: false
      t.string  :city_address, null: false
      t.string  :building
      t.string  :phone_number
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end