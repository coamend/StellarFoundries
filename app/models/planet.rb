class Planet < ActiveRecord::Base
  belongs_to :system
  belongs_to :planet_type
  has_many :moons, class_name: "Planet",
           foreign_key: "parent_planet_id",
           primary_key: "id",
           dependent: :destroy
  has_many :regions,
           dependent: :destroy
  has_many :ores,
           dependent: :destroy
  belongs_to :parent_planet, class_name: "Planet",
             foreign_key: "parent_planet_id",
             primary_key: "id"

  default_scope -> { order(average_orbit: :asc) }

  def generate_planets(system, solar_mass)
    # starting_orbit = 0
    # current_orbit = 0
    previous_orbit = 0

    if system.habitable_zone_inner.nil? || system.habitable_zone_inner == 0 || system.habitable_zone_outer.nil? || system.habitable_zone_outer == 0
      starting_orbit = current_orbit = system.frost_line + Random.rand()
    else
      starting_orbit = current_orbit = Random.rand(system.habitable_zone_inner..system.habitable_zone_outer)
    end

    while current_orbit >= system.inner_orbit_limit do
      if (previous_orbit == 0 || previous_orbit - current_orbit) > 0.15 # make sure orbits aren't too close
        calculate_planet_info(system, current_orbit, solar_mass)
      end

      previous_orbit = current_orbit

      # TODO Magic Numbers!!!
      current_orbit = current_orbit / Random.rand(1.4..2.0)

      puts "Previous Orbit: " + previous_orbit.to_s + " Current Orbit: " + current_orbit.to_s if Rails.env.development?
    end

    # TODO Magic Numbers!!!
    current_orbit = starting_orbit * Random.rand(1.4..2.0)
    previous_orbit = starting_orbit

    while current_orbit <= system.outer_orbit_limit do
      if (previous_orbit == 0 || current_orbit - previous_orbit) > 0.15 # make sure orbits aren't too close
        calculate_planet_info(system, current_orbit, solar_mass)
      end

      previous_orbit = current_orbit

      # TODO Magic Numbers!!!
      current_orbit = current_orbit * Random.rand(1.4..2.0)
      puts "Previous Orbit: " + previous_orbit.to_s + " Current Orbit: " + current_orbit.to_s if Rails.env.development?
    end
  end

  def calculate_planet_info(system, orbit, solar_mass)
    mass = 0
    radius = 0
    density = 0
    # TODO Magic number!!!
    eccentricity = Random.rand(0.0..0.1)

    if system.forbidden_zone_outer.nil? || orbit > system.forbidden_zone_outer
      if system.forbidden_zone_inner.nil? || orbit < system.forbidden_zone_inner # orbit is outside the forbidden zone
        planet_roll = Random.rand(1..100)

        if orbit >= system.frost_line
          # More gas giants outside of Frost Line

          # TODO Magic Numbers!!!
          case planet_roll
            when (1..40)
              # Gas giant
              if planet_roll.in?(1..30)
                planet_type = PlanetType.find_by(name: 'Gas Giant').id
                mass = Random.rand(10.0..4132.0)
                radius = Math.log10(10 * mass) + Random.rand(1.5..5.0)

                # Gas giants more massive than 2Mj collapse at 11 Re, so adjust it to max out somewhere around there
                if mass > 635.0
                  if radius > 11.0
                    radius = 10.5 + Random.rand()
                  end
                end

                density = mass / (radius ** 3)
              else
                # Gas Dwarf

                planet_type = PlanetType.find_by(name: 'Gas Dwarf').id
                mass = Random.rand(1.0..20.0)
                radius = Math.log10(10 * mass) + Random.rand(0.5..3.0)
                density = mass / (radius ** 3)
              end
            when (41..75)
              # Terrestrial

              if planet_roll.in?(41..60)
                # Sub-Earth

                planet_type = PlanetType.find_by(name: 'Sub Earth').id

                mass = Random.rand(0.1..1.0)
                density = Random.rand(0.5..2.0)
                radius = (mass / density)**(1.0/3.0)
              else
                # Super-Earth

                planet_type = PlanetType.find_by(name: 'Super Earth').id

                mass = Random.rand(1.0..10.0)
                density = Random.rand(0.5..2.0)
                radius = (mass / density)**(1.0/3.0)
              end
            when (76..80)
              # Brown Dwarf

              planet_type = PlanetType.find_by(name: 'Brown Dwarf').id

              mass = Random.rand(635..25426)
              radius = 11 + Random.rand
              density = mass / (radius ** 3)
            when (81..90)
              # Asteroid belt

              planet_type = PlanetType.find_by(name: 'Asteroid Belt').id

              mass = Random.rand(0.0001..0.02) * orbit
            else
              # Empty orbit
          end
        else
          # More terrestrials inside of Frost Line

          # TODO Magic Numbers!!!
          case planet_roll
            when (1..10)
              # Gas giant

              if orbit > 0.5
                planet_type = PlanetType.find_by(name: 'Gas Giant').id

                mass = Random.rand(10.0..4132.0)
                radius = Math.log10(10 * mass) + Random.rand(1.5..5.0)

                # Gas giants more massive than 2Mj collapse at 11 Re, so adjust it to max out somewhere around there
                if mass > 635.0
                  if radius > 11.0
                    radius = 10.5 + Random.rand()
                  end
                end
              elsif orbit > 0.04
                # Puffy Giant / Hot Jupiter

                planet_type = PlanetType.find_by(name: 'Puffy Giant').id

                mass = Random.rand(10.0..4132.0)
                radius = radius = Math.log10(10 * mass) + Random.rand(1.5..18.0)

              end

              density = mass / (radius ** 3)
            when (11..70)
              # Terrestrial

              if planet_roll.in?(11..40)
                # Sub-Earth

                planet_type = PlanetType.find_by(name: 'Sub Earth').id

                mass = Random.rand(0.1..1.0)
                density = Random.rand(0.5..2.0)
                radius = (mass / density)**(1.0/3.0)
              else
                # Super-Earth

                planet_type = PlanetType.find_by(name: 'Super Earth').id

                mass = Random.rand(1.0..10.0)
                density = Random.rand(0.5..2.0)
                radius = (mass / density)**(1.0/3.0)
              end
            when (71..85)
              # Asteroid belt

              planet_type = PlanetType.find_by(name: 'Asteroid Belt').id

              mass = Random.rand(0.0001..0.02) * orbit
            when (86..90)
              # Brown Dwarf

              planet_type = PlanetType.find_by(name: 'Brown Dwarf').id

              mass = Random.rand(635..25426)
              radius = 11 + Random.rand
              density = mass / (radius ** 3)
            else
              # Empty orbit
          end
        end

        if mass > 0
          if radius > 0
            surface_area = 4 * Math::PI * (radius ** 2)
          end

          if Random.rand(1..100) <= 75
            #Prograde orbit
            obliquity = Random.rand(0..90)
          else
            #Retrograde orbit
            obliquity = Random.rand(91..180)
          end

          planet = Planet.new(name: system.name + ' ' + orbit.round(2).to_s,
                              system_id: system.id,
                              average_orbit: orbit,
                              eccentricity: eccentricity,
                              mass: mass,
                              radius: radius,
                              density: density,
                              planet_type_id: planet_type,
                              surface_area: surface_area,
                              axial_tilt: obliquity)

          planet.save

          # Generate ores
          puts "Generating Ores!" if Rails.env.development?
          Ore.generate_ore(planet, system)
        end

        if radius > 0
          # Check for moons
          num_moons = 0

          # TODO Magic Numbers!!!
          max_orbit = calculate_hill_sphere(solar_mass, mass, orbit, eccentricity) / 2.0
          min_orbit = calculate_roche_limit(radius, density, density * 0.8) * 0.0000426 #translated to AU from Re

          if min_orbit < max_orbit
            current_orbit = (max_orbit + min_orbit) / 2.0

            moon_chance = 0

            while current_orbit > min_orbit
              moon_chance = Random.rand(0.0..100.0)

              # TODO Magic Numbers!!!
              if moon_chance < (10 * Math.sqrt(mass)) - (5 * num_moons)
                # Generate Moon
                Moon.calculate_moon_info(system, planet, current_orbit)

                num_moons += 1
              end

              current_orbit = current_orbit / Random.rand(1.4..2.0)
            end

            current_orbit = ((max_orbit + min_orbit) / 2.0) * Random.rand(1.4..2.0)

            while current_orbit < max_orbit
              moon_chance = Random.rand(0.0..100.0)

              # TODO Magic Numbers!!!
              if moon_chance < (10 * Math.sqrt(mass)) - (5 * num_moons)
                # Generate Moon
                Moon.calculate_moon_info(system, planet, current_orbit)

                num_moons += 1
              end

              current_orbit = current_orbit * Random.rand(1.4..2.0)
            end
          end
        end
      end
    end

  end

  def calculate_hill_sphere(primary, secondary, orbit, eccentricity)
    min_orbit = orbit * (1.0 - eccentricity)
    sphere = (primary / (3 * secondary))**(1.0/3.0)

    min_orbit * sphere
  end

  def calculate_roche_limit(primary_radius, primary_density, secondary_density)
    1.26 * primary_radius * ((primary_density / secondary_density)**(1.0/3.0))
  end
end
