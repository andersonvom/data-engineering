class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name, null: false
      t.string :file_name, null: false
      t.boolean :imported, default: false

      t.timestamps
    end
  end
end
