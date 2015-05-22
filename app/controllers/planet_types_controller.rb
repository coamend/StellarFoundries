class PlanetTypesController < ApplicationController
  before_action :set_planet_type, only: [:show, :edit, :update, :destroy]

  # GET /planet_types
  # GET /planet_types.json
  def index
    @planet_types = PlanetType.all
  end

  # GET /planet_types/1
  # GET /planet_types/1.json
  def show
  end

  # GET /planet_types/new
  def new
    @planet_type = PlanetType.new
  end

  # GET /planet_types/1/edit
  def edit
  end

  # POST /planet_types
  # POST /planet_types.json
  def create
    @planet_type = PlanetType.new(planet_type_params)

    respond_to do |format|
      if @planet_type.save
        format.html { redirect_to @planet_type, notice: 'Planet type was successfully created.' }
        format.json { render :show, status: :created, location: @planet_type }
      else
        format.html { render :new }
        format.json { render json: @planet_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /planet_types/1
  # PATCH/PUT /planet_types/1.json
  def update
    respond_to do |format|
      if @planet_type.update(planet_type_params)
        format.html { redirect_to @planet_type, notice: 'Planet type was successfully updated.' }
        format.json { render :show, status: :ok, location: @planet_type }
      else
        format.html { render :edit }
        format.json { render json: @planet_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /planet_types/1
  # DELETE /planet_types/1.json
  def destroy
    @planet_type.destroy
    respond_to do |format|
      format.html { redirect_to planet_types_url, notice: 'Planet type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planet_type
      @planet_type = PlanetType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def planet_type_params
      params.require(:planet_type).permit(:name)
    end
end
