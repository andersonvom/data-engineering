class CreateImportItems < ActiveRecord::Migration
  def change
    create_table :import_items do |t|
      t.belongs_to :import, index: true, null: false
      t.integer :line_number, null: false
      t.string :data

      t.timestamps
    end
    add_index :import_items, [:import_id, :line_number], unique: true
  end
end
