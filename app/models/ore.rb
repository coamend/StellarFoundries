class Ore < ActiveRecord::Base
  belongs_to :planet
  belongs_to :ore_type

  def generate_ore(planet, system)
    case planet.planet_type.name
      when 'Gas Giant'
        minerals = []
      when 'Gas Dwarf'
      when 'Puffy Giant'
      when 'Sub Earth'
        # TODO: use a hash here rather than an array
        minerals = [1,1,1,1,1,1,1,1,1,1,1]
        add_ore_ratios(planet, minerals)
      when 'Super Earth'
        minerals = [1,1,1,1,1,1,1,1,1,1,1]
        add_ore_ratios(planet, minerals)
      when 'Asteroid Belt'
      when 'Brown Dwarf'
      when 'Ring'
      when 'Moon'
    end
=begin
  Noble Gas (suspension / cooling / beam weapon) http://en.wikipedia.org/wiki/Noble_gas
  Polyatomic Nonmetal (electrical / alloy)                  http://en.wikipedia.org/wiki/Nonmetal
  Diatomic Nonmetal (life support / beam weapon) http://en.wikipedia.org/wiki/Nonmetal
  Metalloid (electrical / computer / alloy)                   http://en.wikipedia.org/wiki/Metalloid
  Alkaline Earth Metal (insulation / alloy)                   http://en.wikipedia.org/wiki/Alkaline_earth_metal
  Alkali Metal (life support / capacitor / computer)  http://en.wikipedia.org/wiki/Alkali_metal
  Base Metal (construction / structure)                       http://en.wikipedia.org/wiki/Base_metal
  Noble Metal (electrical / life support)                      http://en.wikipedia.org/wiki/Noble_metal
  Refractory Metal (armor / hull)                                 http://en.wikipedia.org/wiki/Refractory_metals
  Rare Earth Element (magnet / beam weapon)       http://en.wikipedia.org/wiki/Rare_earth_element
  Actinide (nuclear / generator)                                   http://en.wikipedia.org/wiki/Actinide
=end
  end

  def add_ore_ratios(planet, quantities)
    earth_values = [1,2,3,4,5,6,7,8,9,10,11]
    ratio = (planet.radius / 3)
    amount = ratio * (quantities[0] / 4) * Random.rand(1..16) * earth_values# .25 - 4x amount given
  end
end
