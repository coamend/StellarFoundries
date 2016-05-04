class Galaxy < ActiveRecord::Base
  has_many :quadrants, dependent: :destroy

  def generate_galaxy(turn_number,
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
      quadrant = Quadrant.generate_quadrants(galaxy,
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

  def generate_galaxy_async(turn_number,
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
end
