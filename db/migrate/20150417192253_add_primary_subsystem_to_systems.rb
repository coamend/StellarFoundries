class AddPrimarySubsystemToSystems < ActiveRecord::Migration
  def change
    add_column :systems, :primary_star_id, :integer
    add_column :systems, :secondary_star_id, :integer
    add_column :systems, :binary_average_distance, :float
    add_column :systems, :barycenter, :float
    add_column :systems, :primary_eccentricity, :float
    add_column :systems, :secondary_eccentricity, :float
    add_column :systems, :primary_max_distance, :float
    add_column :systems, :secondary_max_distance, :float
    add_column :systems, :primary_min_distance, :float
    add_column :systems, :secondary_min_distance, :float
    add_column :systems, :inner_orbit_limit, :float
    add_column :systems, :outer_orbit_limit, :float
    add_column :systems, :frost_line, :float
    add_column :systems, :habitable_zone_inner, :float
    add_column :systems, :habitable_zone_outer, :float
    add_column :systems, :forbidden_zone_inner, :float
    add_column :systems, :forbidden_zone_outer, :float

    add_column :systems, :primary_subsystem_id, :integer
    add_column :systems, :secondary_subsystem_id, :integer
    add_column :systems, :subsystem_average_distance, :float
    add_column :systems, :subsystem_barycenter, :float
    add_column :systems, :primary_subsystem_eccentricity, :float
    add_column :systems, :secondary_subsystem_eccentricity, :float
    add_column :systems, :primary_subsystem_max_distance, :float
    add_column :systems, :secondary_subsystem_max_distance, :float
    add_column :systems, :primary_subsystem_min_distance, :float
    add_column :systems, :secondary_subsystem_min_distance, :float
  end
end
