class CreateOres < ActiveRecord::Migration
  def change
    create_table :ores do |t|
      t.integer :depth
      t.integer :size
      t.float :strip_ratio

      t.timestamps null: false
    end
  end
end
