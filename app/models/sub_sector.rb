class SubSector < ActiveRecord::Base
  belongs_to :sector
  has_one :system, dependent: :destroy

  def self.generate_subsectors(sector,
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
            system = System.generate_system(sub_sector)

            unless system
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
end
