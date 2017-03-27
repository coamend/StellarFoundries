class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :average_temperature
      t.integer :temperature_variance
      t.integer :maximum_latitude
      t.integer :minimum_latitude

      t.timestamps null: false
    end
  end
end
