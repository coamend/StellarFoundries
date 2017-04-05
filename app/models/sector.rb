class Sector < ActiveRecord::Base
  belongs_to :quadrant
  has_many :sub_sectors, dependent: :destroy

  def self.generate_sectors(quadrant,
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
          sub_sector = SubSector.generate_subsectors(sector,
                                          sub_sector_x,
                                          sub_sector_y)

          unless sub_sector
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
end
