class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :import, index: true, null: false
      t.references :purchaser, index: true, null: false
      t.references :inventory_item, index: true, null: false
      t.integer :price_in_cents, null: false
      t.integer :count, null: false

      t.timestamps
    end
  end
end
