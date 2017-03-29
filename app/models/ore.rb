class Ore < ActiveRecord::Base
  belongs_to :planet
  belongs_to :ore_type

  def generate_ore(planet, system)
    case planet.planet_type.name
      when 'Gas Giant'
        minerals = {
            "Noble Gas" => 1,
            "Polyatomic Nonmetal" => 5,
            "Diatomic Nonmetal" => 100,
            "Metalloid" => 0.1,
            "Alkaline Earth Metal" => 0.1,
            "Alkali Metal" => 0.1,
            "Base Metal" => 0.1,
            "Noble Metal" => 0.01,
            "Refractory Metal" => 0.1,
            "Rare Earth Element" => 0.001,
            "Actinide" => 0.001
        }
        add_ore_ratios(planet, minerals)

      when 'Gas Dwarf'
        minerals = {
            "Noble Gas" => 2,
            "Polyatomic Nonmetal" => 2,
            "Diatomic Nonmetal" => 5,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 1,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 1,
            "Actinide" => 1
        }
        add_ore_ratios(planet, minerals)

      when 'Puffy Giant'
        minerals = {
            "Noble Gas" => 1,
            "Polyatomic Nonmetal" => 1,
            "Diatomic Nonmetal" => 100,
            "Metalloid" => 0.1,
            "Alkaline Earth Metal" => 0.1,
            "Alkali Metal" => 0.1,
            "Base Metal" => 0.1,
            "Noble Metal" => 0.01,
            "Refractory Metal" => 0.1,
            "Rare Earth Element" => 0.001,
            "Actinide" => 0.001
        }
        add_ore_ratios(planet, minerals)

      when 'Sub Earth'
        minerals = {
            "Noble Gas" => 1,
            "Polyatomic Nonmetal" => 1,
            "Diatomic Nonmetal" => 1,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 1,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 1,
            "Actinide" => 1
        }
        add_ore_ratios(planet, minerals)

      when 'Super Earth'
        minerals = {
            "Noble Gas" => 1,
            "Polyatomic Nonmetal" => 1,
            "Diatomic Nonmetal" => 1,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 1,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 1,
            "Actinide" => 1
        }
        add_ore_ratios(planet, minerals)

      when 'Asteroid Belt'
        minerals = {
            "Noble Gas" => 0.01,
            "Polyatomic Nonmetal" => 5,
            "Diatomic Nonmetal" => 0.01,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 5,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 1,
            "Actinide" => 1
        }
        add_ore_ratios(planet, minerals)

      when 'Brown Dwarf'
        minerals = {
            "Noble Gas" => 0.01,
            "Polyatomic Nonmetal" => 0.01,
            "Diatomic Nonmetal" => 0.01,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 1,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 2,
            "Actinide" => 2
        }
        add_ore_ratios(planet, minerals)

      when 'Ring'
        minerals = {
            "Noble Gas" => 0.1,
            "Polyatomic Nonmetal" => 1,
            "Diatomic Nonmetal" => 1,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 0.1,
            "Noble Metal" => 0.001,
            "Refractory Metal" => 0.1,
            "Rare Earth Element" => 0.001,
            "Actinide" => 0.001
        }
        add_ore_ratios(planet, minerals)

      when 'Moon'
        minerals = {
            "Noble Gas" => 1,
            "Polyatomic Nonmetal" => 1,
            "Diatomic Nonmetal" => 1,
            "Metalloid" => 1,
            "Alkaline Earth Metal" => 1,
            "Alkali Metal" => 1,
            "Base Metal" => 1,
            "Noble Metal" => 1,
            "Refractory Metal" => 1,
            "Rare Earth Element" => 1,
            "Actinide" => 1
        }
        add_ore_ratios(planet, minerals)

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
    earth_size = 5.972 * (10 ** 19) # Mass of the crust of the earth, in tons
    size_ratio = (planet.radius / 3)

    total = quantities.values.sum()

    OreType.all().each do |type|
      if quantities.has_key?(type.name)
        quantity_ratio = quantities[type.name] / total
        mineral_ratio = quantity_ratio * size_ratio

        ore = Ore.new(
            planet_id: planet.id,
            ore_type: type,
            depth: (Random.rand(-1000.0..1000.0) * planet.radius).to_int,
            size: (mineral_ratio / 4 * Random.rand(1.0..16.0) * earth_size).to_int,
            strip_ratio: Random.rand(1.0..80.0) / quantity_ratio
        )
        ore.save
      end
    end
  end
end
