class Quadrant < ActiveRecord::Base
  belongs_to :galaxy
  has_many :sectors, dependent: :destroy

  def generate_quadrants(galaxy,
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
          sector = Sector.generate_sectors(quadrant,
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
end
