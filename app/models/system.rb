class System < ActiveRecord::Base
  belongs_to :sub_sector

  has_one :primary_star, class_name: "Star",
                          foreign_key: "id",
                          primary_key: "primary_star_id",
                          dependent: :destroy
  has_one :secondary_star, class_name: "Star",
                          foreign_key: "id",
                          primary_key: "secondary_star_id",
                          dependent: :destroy

  belongs_to :parent_system, class_name: "System",
                              foreign_key: "id",
                              primary_key: "parent_system_id"
  has_one :primary_subsystem, class_name: "System",
                              foreign_key: "id",
                              primary_key: "primary_subsystem_id",
                              dependent: :destroy
  has_one :secondary_subsystem, class_name: "System",
                                foreign_key: "id",
                                primary_key: "secondary_subsystem_id",
                                dependent: :destroy

  has_many :planets, dependent: :destroy

  def generate_system(sub_sector)
    system = sub_sector.build_system(name: "System " + sub_sector.id.to_s)

    if system.save
      primary_star = Star.generate_star(system, 'A')
    else
      return false
    end

    # TODO Magic Number!!!
    if Random.rand(1..100) <= 33
      # multi-star system
      secondary_star = Star.generate_star(system, 'B')
      # primary_system_type = nil
      # secondary_system_type = nil
      # tertiary_star = nil
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
        tertiary_star = Star.generate_star(system, 'C')

        primary_subsystem_mass = primary_star.mass + secondary_star.mass
        secondary_subsystem_mass = tertiary_star.mass

        # TODO Magic Number!!!
        if Random.rand(1..100) <= 33
          # quarternary system
          quartile_star = Star.generate_star(system, 'D')

          secondary_subsystem_mass += quartile_star.mass
        end

        primary_subsystem = System.new(sub_sector_id: sub_sector,
                                       name: "System " + sub_sector.id.to_s + "a")
        primary_subsystem.save

        secondary_subsystem = System.new(sub_sector_id: sub_sector,
                                         name: "System " + sub_sector.id.to_s + "b")
        secondary_subsystem.save

        # barycenter = 0

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

        generate_subsystems(primary_system_type,
                           primary_subsystem,
                           sub_sector,
                           primary_star,
                           secondary_star)

        if quartile_star.nil?
          calculate_system_info(secondary_subsystem, tertiary_star)
        else
          generate_subsystems(secondary_system_type,
                             secondary_subsystem,
                             sub_sector,
                             tertiary_star,
                             quartile_star)
        end
      else
        # binary system
        generate_subsystems(primary_system_type,
                           system,
                           sub_sector,
                           primary_star,
                           secondary_star)
      end
    else
      # solitary system
      calculate_system_info(system, primary_star)
    end

    system
  end

  def generate_subsystems(system_type,
                         parent_system,
                         sub_sector,
                         primary_star,
                         secondary_star)
    if system_type == 'P'
      calculate_system_info(parent_system, primary_star, secondary_star)

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
      calculate_system_info(primary_subsystem_a, primary_star)

      primary_subsystem_b = System.new(sub_sector_id: sub_sector.id,
                                       name: "System " + sub_sector.id.to_s + suffix_2, parent_system_id: parent_system.id)
      primary_subsystem_b.save
      calculate_system_info(primary_subsystem_b, secondary_star)

      # barycenter = 0

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

  def calculate_system_info(system, primary_star, secondary_star = nil, iteration = 0)
    # mass = 0
    # luminosity = 0
    # luminosity_sqrt = 0
    forbidden_zone_inner = 0
    forbidden_zone_outer = 0

    if secondary_star.nil?
      system.primary_star_id = primary_star.id
      mass = primary_star.mass
      luminosity = Float(primary_star.luminosity)
    else # P-Type binary
      # barycenter = 0

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
        calculate_system_info(system, primary_star, secondary_star, iteration + 1)
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

    Planet.generate_planets(system, mass)
  end
end
