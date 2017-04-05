class Region < ActiveRecord::Base
  belongs_to :planet

  def self.generate_regions(planet, system)
    distance = planet.average_orbit * 107.5176 # converting from au to solar diameters
    planetary_equilibrium_temperature = system.get_total_star_energy(distance) # in solar surface temperatures ~5780 K

    # Tropic of Cancer 0 - Tilt degrees north
    # Tropic of Capricorn 0 - Tilt degrees south
    # Arctic Circle 90 - Tropic of Cancer degrees north
    # Antarctic Circle 90 - Tropic of Capricorn degrees south
    # If tilt > 54 degrees, then tropics and poles switch
    # If tilt = 0 degrees, then tropics are 30 degrees n/s, polar circle are 50 degrees n/s
  end
end
