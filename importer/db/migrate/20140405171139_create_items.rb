class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :merchant, index: true, null: false
      t.string :description, null: false

      t.timestamps
    end
    add_index :items, [:merchant_id, :description], unique: true
  end
end
