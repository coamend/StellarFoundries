class Planet < ActiveRecord::Base
  belongs_to :system
  belongs_to :planet_type
  has_many :moons, class_name: "Planet",
           foreign_key: "parent_planet_id",
           primary_key: "id",
           dependent: :destroy
  belongs_to :parent_planet, class_name: "Planet",
             foreign_key: "parent_planet_id",
             primary_key: "id"

  default_scope -> { order(average_orbit: :asc) }
end
