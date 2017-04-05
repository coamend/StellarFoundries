class AddOreTypeToOres < ActiveRecord::Migration
  def change
    add_column :ores, :ore_type_id, :integer
  end
end
