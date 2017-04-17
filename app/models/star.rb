class Star < ActiveRecord::Base
  belongs_to :system

  def self.generate_star(system, star_letter)
    rand_solar_class = Random.rand() * 100
    # solar_class = 'M'
    # solar_mass = 0

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
    if(solar_mass < 0.43) # Brown dwarf
      luminosity = 0.23 * (solar_mass ** 2.3)
    elsif(solar_mass < 2) # 0.43 < solar_mass < 2
      luminosity = solar_mass ** 4
    elsif(solar_mass < 20) # 2 < solar_mass < 20
      luminosity = 1.5 * (solar_mass ** 3.5)
    else # Solar mass is >= 20
      luminosity = solar_mass * 3200
    end

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

  def self.get_star_energy(star, distance)
    temp = Converter.convert(:temperature, star.surface_temperature, :solar_temperatures, :kelvin)
    radius = Converter.convert(:distance, star.diameter, :solar_diameters, :km) / 2.0
    orbital_distance = Converter.convert(:distance, distance, :au, :km)
    energy = temp * Math.sqrt(radius / (2.0 * orbital_distance))

    puts "Surface Temperature: " + temp.to_s + "K" if Rails.env.development?
    puts "Size/Distance Factor: ("+ radius.to_s + " / 2 * " + orbital_distance.to_s + ") " + (radius / (2.0 * orbital_distance)).to_s if Rails.env.development?
    puts "Star Energy: " + energy.to_s if Rails.env.development?
    energy
  end
end
