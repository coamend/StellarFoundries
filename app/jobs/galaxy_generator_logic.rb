require 'stalker'

module GalaxyGeneratorLogic
  def GenerateGalaxy(turn_number,
                    turn_frequency,
                    name,
                    last_turn_at,
                    quadrant_x,
                    quadrant_y,
                    sector_x,
                    sector_y,
                    sub_sector_x,
                    sub_sector_y)

    galaxy = Galaxy.new(turn_number: turn_number,
                         turn_frequency: turn_frequency,
                         name: name,
                         last_turn_at: last_turn_at
    )

    if galaxy.save
      quadrant = GenerateQuadrants(galaxy,
                                    quadrant_x,
                                    quadrant_y,
                                    sector_x,
                                    sector_y,
                                    sub_sector_x,
                                    sub_sector_y)

      if quadrant
        puts "Galaxy successfully created! - " + galaxy.name if Rails.env.development?
      else
        galaxy.errors += quadrant.errors
      end
    end

    galaxy
  end

  def GenerateGalaxyAsync(turn_number,
                     turn_frequency,
                     name,
                     last_turn_at,
                     quadrant_x,
                     quadrant_y,
                     sector_x,
                     sector_y,
                     sub_sector_x,
                     sub_sector_y)

    galaxy = Galaxy.new(turn_number: turn_number,
                        turn_frequency: turn_frequency,
                        name: name,
                        last_turn_at: last_turn_at
    )

    if galaxy.save
      Stalker.enqueue("generate_galaxy_async",
                      { :galaxy_id => galaxy.id,
                        :quadrant_x => quadrant_x,
                        :quadrant_y => quadrant_y,
                        :sector_x => sector_x,
                        :sector_y => sector_y,
                        :sub_sector_x => sub_sector_x,
                        :sub_sector_y => sub_sector_y})
    end

    galaxy
  end

  def GenerateQuadrants(galaxy,
                       quadrant_x,
                       quadrant_y,
                       sector_x,
                       sector_y,
                       sub_sector_x,
                       sub_sector_y)

    puts "Quadrant X: " + quadrant_x if Rails.env.development?

    qx = 1
    while qx <= (quadrant_x.to_i) do
      qy = 1

      while qy <= (quadrant_y.to_i) do
        quadrant = galaxy.quadrants.build(name: "Quadrant" + qx.to_s + qy.to_s,
                                quadrant_x: qx,
                                quadrant_y: qy)

        if quadrant.save
          sector = GenerateSectors(quadrant,
                          sector_x,
                          sector_y,
                          sub_sector_x,
                          sub_sector_y)

          if !sector
            quadrant.errors = sector.errors
            return quadrant
          end
        else
          return quadrant
        end

        qy += 1
      end

      qx += 1
    end

    quadrant
  end

  def GenerateSectors(quadrant,
                     sector_x,
                     sector_y,
                     sub_sector_x,
                     sub_sector_y)

    sx = 1
    while sx <= sector_x.to_i do
      sy = 1

      while sy <= sector_y.to_i do
        sector = quadrant.sectors.build(sector_x: sx,
                             sector_y: sy)

        if sector.save
          sub_sector = GenerateSubsectors(sector,
                            sub_sector_x,
                            sub_sector_y)

          if !sub_sector
            sector.errors = sub_sector.errors
            return sector
          end
        else
          return sector
        end

        sy += 1
      end

      sx += 1
    end

    sector
  end

  def GenerateSubsectors(sector,
                        sub_sector_x,
                        sub_sector_y)

    ssx = 1
    while ssx <= sub_sector_x.to_i
      ssy = 1

      while ssy <= sub_sector_y.to_i
        sub_sector = sector.sub_sectors.build(subsector_x: ssx,
                             subsector_y: ssy)

        if sub_sector.save
          # TODO Magic Number!!!
          if Random.rand(1..100) <= 8
            system = GenerateSystem(sub_sector)

            if !system
              sub_sector.errors = system.errors
              return sub_sector
            end

            puts "System generated in subsector: " + ssx.to_s + " " + ssy.to_s if Rails.env.development?
          else
            puts "No system in: " + ssx.to_s + " " + ssy.to_s if Rails.env.development?
          end
        else
          return sub_sector
        end

        ssy += 1
      end

      ssx += 1
    end

    sub_sector
  end

  def GenerateSystem(sub_sector)
    system = sub_sector.build_system(name: "System " + sub_sector.id.to_s)

    if system.save
      primary_star = GenerateStar(system, 'A')
    else
      false
    end

    # TODO Magic Number!!!
    if Random.rand(1..100) <= 33
      # multi-star system
      secondary_star = GenerateStar(system, 'B')
      primary_system_type = nil
      secondary_system_type = nil
      tertiary_star = nil
      quartile_star = nil

      # TODO Magic Number!!!
      if Random.rand(1..100) <= 50
        # P-Type primary binary system
        primary_system_type = 'P'
      else
        # S-Type primary binary system
        primary_system_type = 'S'
      end

      # TODO Magic Number!!!
      if Random.rand(1..100) <= 33
        # trinary system
        tertiary_star = GenerateStar(system, 'C')

        primary_subsystem_mass = primary_star.mass + secondary_star.mass
        secondary_subsystem_mass = tertiary_star.mass

        # TODO Magic Number!!!
        if Random.rand(1..100) <= 33
          # quarternary system
          quartile_star = GenerateStar(system, 'D')

          secondary_subsystem_mass += quartile_star.mass
        end

        primary_subsystem = System.new(sub_sector_id: sub_sector,
                                        name: "System " + sub_sector.id.to_s + "a")
        primary_subsystem.save

        secondary_subsystem = System.new(sub_sector_id: sub_sector,
                                          name: "System " + sub_sector.id.to_s + "b")
        secondary_subsystem.save

        barycenter = 0

        # TODO Magic Number!!!
        system.subsystem_average_distance = Random.rand(1200..60000)

        if primary_subsystem_mass >= secondary_subsystem_mass
          system.primary_subsystem_id = primary_subsystem.id
          system.secondary_subsystem_id = secondary_subsystem.id

          barycenter = system.subsystem_average_distance * (secondary_subsystem_mass / primary_subsystem_mass + secondary_subsystem_mass)
        else
          system.primary_subsystem_id = secondary_subsystem.id
          system.secondary_subsystem_id = primary_subsystem.id

          barycenter = system.subsystem_average_distance * (primary_subsystem_mass / secondary_subsystem_mass + primary_subsystem_mass)
        end

        system.subsystem_barycenter = barycenter

        # TODO Magic Number!!!
        system.primary_subsystem_eccentricity = Random.rand(0..70) * 0.01
        system.secondary_subsystem_eccentricity = Random.rand(0..70) * 0.01
        system.primary_subsystem_max_distance = barycenter * (1 + system.primary_subsystem_eccentricity)
        system.secondary_subsystem_max_distance = barycenter * (1 + system.secondary_subsystem_eccentricity)
        system.primary_subsystem_min_distance = barycenter * (1 - system.primary_subsystem_eccentricity)
        system.secondary_subsystem_min_distance = barycenter * (1 - system.secondary_subsystem_eccentricity)

        max_separation = system.primary_subsystem_max_distance + system.secondary_subsystem_max_distance
        min_separation = system.primary_subsystem_min_distance + system.secondary_subsystem_min_distance

        forbidden_zone_inner = min_separation / 3
        forbidden_zone_outer = max_separation * 3

        system.forbidden_zone_inner = forbidden_zone_inner
        system.forbidden_zone_outer = forbidden_zone_outer

        puts "Barycenter: " + barycenter.to_s + " Primary_mass: " + primary_subsystem_mass.to_s + " Secondary_mass: " + secondary_subsystem_mass.to_s if Rails.env.development?

        system.save

        # TODO Magic Number!!!
        if Random.rand(1..100) <= 50
          # P-Type secondary binary system
          secondary_system_type = 'P'
        else
          # S-Type secondary binary system
          secondary_system_type = 'S'
        end

        GenerateSubSystems(primary_system_type,
                           primary_subsystem,
                           sub_sector,
                           primary_star,
                           secondary_star)

        if quartile_star.nil?
          CalculateSystemInfo(secondary_subsystem, tertiary_star)
        else
          GenerateSubSystems(secondary_system_type,
                             secondary_subsystem,
                             sub_sector,
                             tertiary_star,
                             quartile_star)
        end
      else
        # binary system
        GenerateSubSystems(primary_system_type,
                           system,
                           sub_sector,
                           primary_star,
                           secondary_star)
      end
    else
      # solitary system
      CalculateSystemInfo(system, primary_star)
    end

    system
  end

  def GenerateSubSystems(system_type,
                         parent_system,
                         sub_sector,
                         primary_star,
                         secondary_star)
    if system_type == 'P'
      CalculateSystemInfo(parent_system, primary_star, secondary_star)

    else # S-Type multi-star system
      if ('A'..'D').include?parent_system.name.last(1)
        suffix_1 = primary_star.name.last(1)
        suffix_2 = secondary_star.name.last(1)
      else
        suffix_1 = 'A'
        suffix_2 = 'B'
      end

      primary_subsystem_a = System.new(sub_sector_id: sub_sector.id,
                                        name: "System " + sub_sector.id.to_s + suffix_1, parent_system_id: parent_system.id)
      primary_subsystem_a.save
      CalculateSystemInfo(primary_subsystem_a, primary_star)

      primary_subsystem_b = System.new(sub_sector_id: sub_sector.id,
                                        name: "System " + sub_sector.id.to_s + suffix_2, parent_system_id: parent_system.id)
      primary_subsystem_b.save
      CalculateSystemInfo(primary_subsystem_b, secondary_star)

      barycenter = 0

      # TODO Magic Number!!!
      parent_system.subsystem_average_distance = Random.rand(120..600)

      if primary_star.mass >= secondary_star.mass
        parent_system.primary_subsystem_id = primary_subsystem_a.id
        parent_system.secondary_subsystem_id = primary_subsystem_b.id

        barycenter = parent_system.subsystem_average_distance * (secondary_star.mass / primary_star.mass + secondary_star.mass)
      else
        parent_system.primary_subsystem_id = primary_subsystem_b.id
        parent_system.secondary_subsystem_id = primary_subsystem_a.id

        barycenter = parent_system.subsystem_average_distance * (primary_star.mass / secondary_star.mass + primary_star.mass)
      end

      parent_system.subsystem_barycenter = barycenter

      # TODO Magic Number!!!
      parent_system.primary_subsystem_eccentricity = Random.rand(0..70) * 0.01
      parent_system.secondary_subsystem_eccentricity = Random.rand(0..70) * 0.01
      parent_system.primary_subsystem_max_distance = barycenter * (1 + parent_system.primary_subsystem_eccentricity)
      parent_system.secondary_subsystem_max_distance = barycenter * (1 + parent_system.secondary_subsystem_eccentricity)
      parent_system.primary_subsystem_min_distance = barycenter * (1 - parent_system.primary_subsystem_eccentricity)
      parent_system.secondary_subsystem_min_distance = barycenter * (1 - parent_system.secondary_subsystem_eccentricity)

      max_separation = parent_system.primary_subsystem_max_distance + parent_system.secondary_subsystem_max_distance
      min_separation = parent_system.primary_subsystem_min_distance + parent_system.secondary_subsystem_min_distance

      forbidden_zone_inner = min_separation / 3
      forbidden_zone_outer = max_separation * 3

      parent_system.forbidden_zone_inner = forbidden_zone_inner
      parent_system.forbidden_zone_outer = forbidden_zone_outer

      puts "Barycenter: " + barycenter.to_s + " Primary_mass: " + primary_star.mass.to_s + " Secondary_mass: " + secondary_star.mass.to_s if Rails.env.development?

      parent_system.save
    end
  end

  def GenerateStar(system, star_letter)
    rand_solar_class = Random.rand() * 100
    solar_class = 'M'
    solar_mass = 0

    # TODO Magic Number!!!
    case rand_solar_class
    when (0..0.00003)
      # O class star
      solar_class = 'O'

      # TODO Magic Number!!!
      solar_mass = Random.rand(160..1100) / 10.0
    when (0.00003..0.13)
      # B class star
      solar_class = 'B'

      # TODO Magic Number!!!
      solar_mass = Random.rand(21..160) / 10.0
    when (0.13..0.73) #.6%
      # A class star
      solar_class = 'A'

      # TODO Magic Number!!!
      solar_mass = Random.rand(140..210) / 100.0
    when (0.73..3.73) #3%
      # F class star
      solar_class = 'F'

      # TODO Magic Number!!!
      solar_mass = Random.rand(104..140) / 100.0
    when (3.73..11.45) #7.6% / 7.72% adjusted for rounding
      # G class star
      solar_class = 'G'

      # TODO Magic Number!!!
      solar_mass = Random.rand(80..104) / 100.0
    when (11.45..23.55) #12.1%
      # K class star
      solar_class = 'K'

      # TODO Magic Number!!!
      solar_mass = Random.rand(45..80) / 100.0
    else # 76.45%
      # M class star
      solar_class = 'M'

      # TODO Magic Number!!!
      solar_mass = Random.rand(8..45) / 100.0
    end

    puts 'Solar Class Roll: ' + rand_solar_class.to_s + ' Solar class: ' + solar_class + 'Solar mass: ' + solar_mass.to_s if Rails.env.development?

    # TODO Magic Number!!!
    luminosity = solar_mass ** 3

    # TODO Magic Number!!!
    diameter = solar_mass ** 0.74

    # TODO Magic Number!!!
    surface_temperature = solar_mass ** 0.505

    star = Star.new(system_id: system.id,
                    name: "Star " + system.id.to_s + star_letter,
                    luminosity: luminosity,
                    mass: solar_mass,
                    diameter: diameter,
                    surface_temperature: surface_temperature,
                    spectral_class: solar_class
                    )

    if star.save
      star
    else
      puts "Failed to generate star!" if Rails.env.development?
      false
    end
  end

  def CalculateSystemInfo(system, primary_star, secondary_star = nil, iteration = 0)
    mass = 0
    luminosity = 0
    luminosity_sqrt = 0
    forbidden_zone_inner = 0
    forbidden_zone_outer = 0

    if secondary_star.nil?
      system.primary_star_id = primary_star.id
      mass = primary_star.mass
      luminosity = Float(primary_star.luminosity)
    else # P-Type binary
      barycenter = 0

      system.name += ' ' + primary_star.name.last(1) + secondary_star.name.last(1)

      # TODO Magic Number!!!
      system.binary_average_distance = Random.rand(15..600) * 0.01

      if primary_star.mass >= secondary_star.mass
        system.primary_star_id = primary_star.id
        system.secondary_star_id = secondary_star.id

        barycenter = system.binary_average_distance * (secondary_star.mass / primary_star.mass + secondary_star.mass)
      else
        system.primary_star_id = secondary_star.id
        system.secondary_star_id = primary_star.id

        barycenter = system.binary_average_distance * (primary_star.mass / secondary_star.mass + primary_star.mass)
      end

      system.barycenter = barycenter

      # TODO Magic Number!!!
      system.primary_eccentricity = Random.rand(0..70) * 0.01
      system.secondary_eccentricity = Random.rand(0..70) * 0.01
      system.primary_max_distance = barycenter * (1 + system.primary_eccentricity)
      system.secondary_max_distance = barycenter * (1 + system.secondary_eccentricity)
      system.primary_min_distance = barycenter * (1 - system.primary_eccentricity)
      system.secondary_min_distance = barycenter * (1 - system.secondary_eccentricity)

      max_separation = system.primary_max_distance + system.secondary_max_distance
      min_separation = system.primary_min_distance + system.secondary_min_distance

      # TODO Magic Number!!!
      if min_separation < 0.1 && iteration < 10
        # Stars too close, need to try again
        CalculateSystemInfo(system, primary_star, secondary_star, iteration + 1)
      elsif iteration >= 10
        puts "Binary star system could not be created because the stars got too close after " + iteration + " iterations" if Rails.env.development?
        return false
      end

      forbidden_zone_inner = min_separation / 3
      forbidden_zone_outer = max_separation * 3

      system.forbidden_zone_inner = forbidden_zone_inner
      system.forbidden_zone_outer = forbidden_zone_outer

      mass = primary_star.mass + secondary_star.mass
      luminosity = Float(primary_star.luminosity) + Float(secondary_star.luminosity)

      puts "Barycenter: " + barycenter.to_s + " Primary_mass: " + primary_star.mass.to_s + " Secondary_mass: " + secondary_star.mass.to_s if Rails.env.development?
    end

    luminosity_sqrt = Math.sqrt(Float(luminosity))

    # TODO Magic number!!!
    system.inner_orbit_limit = 0.1 * mass
    system.outer_orbit_limit = 40 * mass
    system.frost_line = 4.85 * luminosity_sqrt
    system.habitable_zone_inner = 0.95 * luminosity_sqrt
    system.habitable_zone_outer = 1.37 * luminosity_sqrt

    if system.habitable_zone_inner > forbidden_zone_inner && system.habitable_zone_outer < forbidden_zone_outer
      # Habitable zone exists entirely within forbidden zone
      system.habitable_zone_inner = nil
      system.habitable_zone_outer = nil
    elsif system.habitable_zone_inner < forbidden_zone_outer && system.habitable_zone_inner > forbidden_zone_inner
      # Inner limit of habitable zone is within the forbidden zone
      system.habitable_zone_inner = forbidden_zone_outer
    elsif system.habitable_zone_outer < forbidden_zone_outer && system.habitable_zone_outer > forbidden_zone_inner
      # Outer limit of habitable zone is within the forbidden zone
      system.habitable_zone_outer = forbidden_zone_inner
    end

    system.save

    GeneratePlanets(system, mass)
  end

  def GeneratePlanets(system, solar_mass)
    starting_orbit = 0
    current_orbit = 0
    previous_orbit = 0

    if system.habitable_zone_inner.nil? || system.habitable_zone_inner == 0 || system.habitable_zone_outer.nil? || system.habitable_zone_outer == 0
      starting_orbit = current_orbit = system.frost_line + Random.rand()
    else
      starting_orbit = current_orbit = Random.rand(system.habitable_zone_inner..system.habitable_zone_outer)
    end

    while current_orbit >= system.inner_orbit_limit do
      if (previous_orbit - current_orbit) > 0.15 # make sure orbits aren't too close
        CalculatePlanetInfo(system, current_orbit, solar_mass)
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
      if (current_orbit - previous_orbit) > 0.15 # make sure orbits aren't too close
        CalculatePlanetInfo(system, current_orbit, solar_mass)
      end

      previous_orbit = current_orbit

      # TODO Magic Numbers!!!
      current_orbit = current_orbit * Random.rand(1.4..2.0)
      puts "Previous Orbit: " + previous_orbit.to_s + " Current Orbit: " + current_orbit.to_s if Rails.env.development?
    end
  end

  def CalculatePlanetInfo(system, orbit, solar_mass)
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

          planet = Planet.new(name: system.name + ' ' + orbit.round(2).to_s,
                               system_id: system.id,
                               average_orbit: orbit,
                               eccentricity: eccentricity,
                               mass: mass,
                               radius: radius,
                               density: density,
                               planet_type_id: planet_type,
                               surface_area: surface_area)

          planet.save
        end

        if radius > 0
          # Check for moons
          num_moons = 0

          # TODO Magic Numbers!!!
          max_orbit = CalculateHillSphere(solar_mass, mass, orbit, eccentricity) / 2.0
          min_orbit = CalculateRocheLimit(radius, density, density * 0.8) * 0.0000426 #translated to AU from Re

          if min_orbit < max_orbit
            current_orbit = (max_orbit + min_orbit) / 2.0

            moon_chance = 0

            while current_orbit > min_orbit
              moon_chance = Random.rand(0.0..100.0)

              # TODO Magic Numbers!!!
              if moon_chance < (10 * Math.sqrt(mass)) - (5 * num_moons)
                # Generate Moon
                CalculateMoonInfo(system, planet, current_orbit)

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
                CalculateMoonInfo(system, planet, current_orbit)

                num_moons += 1
              end

              current_orbit = current_orbit * Random.rand(1.4..2.0)
            end
          end
        end
      end
    end

  end

  def CalculateMoonInfo(system, planet, orbit)
    moon = Planet.new(name: planet.name + '' + orbit.to_s,
                     parent_planet_id: planet.id,
                     average_orbit: orbit)

    radius = 0
    mass = 0
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

  def CalculateHillSphere(primary, secondary, orbit, eccentricity)
    min_orbit = orbit * (1.0 - eccentricity)
    sphere = (primary / (3 * secondary))**(1.0/3.0)

    min_orbit * sphere
  end

  def CalculateRocheLimit(primary_radius, primary_density, secondary_density)
    1.26 * primary_radius * ((primary_density / secondary_density)**(1.0/3.0))
  end

  def to_roman(number)
    roman_arr = {
        1000 => "M",
        900 => "CM",
        500 => "D",
        400 => "CD",
        100 => "C",
        90 => "XC",
        50 => "L",
        40 => "XL",
        10 => "X",
        9 => "IX",
        5 => "V",
        4 => "IV",
        1 => "I"
    }

    num = number

    roman_arr.reduce("") do |res, (arab, roman)|
      whole_part, num = num.divmod(arab)
      res << roman * whole_part
    end
  end

end