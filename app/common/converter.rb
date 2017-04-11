class Converter

  DISTANCE_FACTORS = {
      :au => { :solar_diameters => 107.5176 }
  }

  def self.convert_distance(distance, convert_from, convert_to)
    factor = DISTANCE_FACTORS[convert_from][convert_to]

    if !factor.nil?
      distance * factor
    else
      factor = DISTANCE_FACTORS[convert_to][convert_from]
      distance / factor
    end
  end
end