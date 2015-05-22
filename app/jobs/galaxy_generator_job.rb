require File.expand_path("../../../config/environment", __FILE__)
require 'galaxy_generator_logic.rb'


job "generate_galaxy_async" do |args|
  include GalaxyGeneratorLogic

  galaxy = Galaxy.find(args["galaxy_id"])

  GenerateQuadrants(galaxy,
                    args["quadrant_x"],
                    args["quadrant_y"],
                    args["sector_x"],
                    args["sector_y"],
                    args["sub_sector_x"],
                    args["sub_sector_y"])
end