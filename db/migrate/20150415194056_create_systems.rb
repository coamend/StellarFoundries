class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.integer :sub_sector_id
      t.string :name

      t.timestamps null: false
    end
  end
end
