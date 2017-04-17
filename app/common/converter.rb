class Converter
  CONVERSION_FACTORS = {
    :distance => {
        :au => {:solar_diameters => 107.5176,
                :solar_radii => 107.5176 * 2,
                :km => 149598000},
        :solar_radii => {:km => 695700},
        :solar_diameters => {:km => 695700 * 2}
    },

    :temperature => {
        :solar_temperatures => {:kelvin => 6000}
    }
  }

  def self.convert(conversion_type, value, convert_from, convert_to)
    hash = CONVERSION_FACTORS[conversion_type]
    factor = hash[convert_from][convert_to]

    if !factor.nil?
      value * factor
    else
      factor = hash[convert_to][convert_from]
      value / factor
    end
  end
end