class CreateMerchantLocations < ActiveRecord::Migration
  def change
    create_table :merchant_locations do |t|
      t.belongs_to :merchant, index: true, null: false
      t.string :address, null: false

      t.timestamps
    end
    add_index :merchant_locations, [:merchant_id, :address], unique: true
  end
end
