class GalaxiesController < ApplicationController
  before_action :set_galaxy, only: [:show, :edit, :update, :destroy]

  # GET /galaxies
  # GET /galaxies.json
  def index
    @galaxies = Galaxy.all
  end

  # GET /galaxies/1
  # GET /galaxies/1.json
  def show
    @quadrants = @galaxy.quadrants.all
  end

  # GET /galaxies/new
  def new
    @galaxy = Galaxy.new
  end

  # GET /galaxies/1/edit
  def edit
  end

  # POST /galaxies
  # POST /galaxies.json
  def create
    @galaxy = Galaxy.generate_galaxy(galaxy_params[:turn_number],
                                     galaxy_params[:turn_frequency],
                                     galaxy_params[:name],
                                     galaxy_params[:last_turn_at],
                                     galaxy_params[:quadrant_x],
                                     galaxy_params[:quadrant_y],
                                     galaxy_params[:sector_x],
                                     galaxy_params[:sector_y],
                                     galaxy_params[:sub_sector_x],
                                     galaxy_params[:sub_sector_y])
        #Galaxy.new(galaxy_params)

    respond_to do |format|
      if @galaxy.save
        format.html { redirect_to @galaxy, notice: 'Galaxy was successfully created.' }
        format.json { render :show, status: :created, location: @galaxy }
      else
        format.html { render :new }
        format.json { render json: @galaxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galaxies/1
  # PATCH/PUT /galaxies/1.json
  def update
    respond_to do |format|
      if @galaxy.update(galaxy_params)
        format.html { redirect_to @galaxy, notice: 'Galaxy was successfully updated.' }
        format.json { render :show, status: :ok, location: @galaxy }
      else
        format.html { render :edit }
        format.json { render json: @galaxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galaxies/1
  # DELETE /galaxies/1.json
  def destroy
    @galaxy.destroy
    respond_to do |format|
      format.html { redirect_to galaxies_url, notice: 'Galaxy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_galaxy
      @galaxy = Galaxy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def galaxy_params
      params.require(:galaxy).permit(:turn_number,
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
