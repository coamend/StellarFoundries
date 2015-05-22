class Moon < ActiveRecord::Base
  belongs_to :planet
  belongs_to :planet_type
  default_scope -> { order(average_orbit: :asc) }
end
