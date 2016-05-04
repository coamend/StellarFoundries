class Moon < ActiveRecord::Base
  belongs_to :planet
  belongs_to :planet_type
  default_scope -> { order(average_orbit: :asc) }

  def calculate_moon_info(system, planet, orbit)
    moon = Planet.new(name: planet.name + '' + orbit.to_s,
                      parent_planet_id: planet.id,
                      average_orbit: orbit)

    radius = 0
    # mass = 0
    density = 0
    surface_area = nil
    # TODO Magic Numbers!!!
    eccentricity = Random.rand(0.0..0.5)
    max_radius = planet.radius * 0.8
    max_mass = planet.mass * 0.8

    moon_type_roll = Random.rand(1..100)

    if orbit < system.frost_line
      case moon_type_roll
        when (1..99)
          # Standard moon

          planet_type = PlanetType.find_by(name: 'Moon').id

          radius = Random.rand(0.01..max_radius)

          if radius * 1.5 < max_mass
            mass = Random.rand(0.01..1.5) * radius
          else
            max_mass_ratio = max_mass / radius
            mass = Random.rand(0.000001..max_mass_ratio) * radius
          end
        else
          # Ring

          planet_type = PlanetType.find_by(name: 'Ring').id

          mass = Random.rand(0.0001..0.02) * orbit
      end
    else
      case moon_type_roll
        when (1..75)
          # Standard moon

          planet_type = PlanetType.find_by(name: 'Moon').id

          radius = Random.rand(0.01..max_radius)

          if radius * 1.5 < max_mass
            mass = Random.rand(0.01..1.5) * radius
          else
            max_mass_ratio = max_mass / radius
            mass = Random.rand(0.000001..max_mass_ratio) * radius
          end
        else
          # Ring

          planet_type = PlanetType.find_by(name: 'Ring').id

          ice_ring_probability = planet.average_orbit / system.frost_line
          ring_type_chance = Random.rand(0.0..ice_ring_probability)

          if ring_type_chance <= 1.0
            # Dust ring
            mass = Random.rand(0.0001..0.02) * orbit
          else
            # Ice ring
            mass = Random.rand(0.0001..0.02) * orbit
          end
      end
    end

    if radius > 0
      density = mass / (radius ** 3)
      surface_area = 4 * Math::PI * (radius ** 2)
    end

    moon.mass = mass
    moon.radius = radius
    moon.density = density
    moon.eccentricity = eccentricity
    moon.planet_type_id = planet_type
    moon.surface_area = surface_area

    moon.save
  end
end
