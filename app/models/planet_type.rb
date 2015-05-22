class PlanetType < ActiveRecord::Base
  has_many :planets
  has_many :moons
end
