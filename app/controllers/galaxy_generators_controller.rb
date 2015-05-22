require 'galaxy_generator_logic'

class GalaxyGeneratorsController < ApplicationController
  include GalaxyGeneratorLogic

  def new
    @galaxy_generator = GalaxyGenerator.new
  end

  def create
=begin
    @galaxy = GenerateGalaxy(galaxy_params[:turn_number],
                                       galaxy_params[:turn_frequency],
                                       galaxy_params[:name],
                                       galaxy_params[:last_turn_at],
                                       galaxy_params[:quadrant_x],
                                       galaxy_params[:quadrant_y],
                                       galaxy_params[:sector_x],
                                       galaxy_params[:sector_y],
                                       galaxy_params[:sub_sector_x],
                                       galaxy_params[:sub_sector_y])
=end
    @galaxy = GenerateGalaxyAsync(galaxy_params[:turn_number],
                             galaxy_params[:turn_frequency],
                             galaxy_params[:name],
                             galaxy_params[:last_turn_at],
                             galaxy_params[:quadrant_x],
                             galaxy_params[:quadrant_y],
                             galaxy_params[:sector_x],
                             galaxy_params[:sector_y],
                             galaxy_params[:sub_sector_x],
                             galaxy_params[:sub_sector_y])

    if @galaxy.errors.size == 0
      redirect_to galaxy_path(@galaxy), notice: 'Galaxy was successfully generated.'
    else
      @galaxy_generator = GalaxyGenerator.new
      @galaxy_generator.errors = @galaxy.errors
      render :new
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def galaxy_params
      params.require(:galaxy_generator).permit(:turn_number,
                                     :turn_frequency,
                                     :name,
                                     :last_turn_at,
                                     :quadrant_x,
                                     :quadrant_y,
                                     :sector_x,
                                     :sector_y,
                                     :sub_sector_x,
                                     :sub_sector_y)
    end
end
