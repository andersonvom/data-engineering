class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.references :merchant_location, index: true, null: false
      t.references :item, index: true, null: false
      t.integer :price_in_cents, null: false

      t.timestamps
    end
    add_index :inventory_items, [:merchant_location_id, :item_id], unique: true
  end
end
