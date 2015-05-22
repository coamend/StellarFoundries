class SubSectorsController < ApplicationController
  before_action :set_sub_sector, only: [:show, :edit, :update, :destroy]

  # GET /sub_sectors
  # GET /sub_sectors.json
  def index
    @sub_sectors = SubSector.all
  end

  # GET /sub_sectors/1
  # GET /sub_sectors/1.json
  def show
    @systems = @sub_sector.system
  end

  # GET /sub_sectors/new
  def new
    @sub_sector = SubSector.new
  end

  # GET /sub_sectors/1/edit
  def edit
  end

  # POST /sub_sectors
  # POST /sub_sectors.json
  def create
    @sub_sector = SubSector.new(sub_sector_params)

    respond_to do |format|
      if @sub_sector.save
        format.html { redirect_to @sub_sector, notice: 'Sub sector was successfully created.' }
        format.json { render :show, status: :created, location: @sub_sector }
      else
        format.html { render :new }
        format.json { render json: @sub_sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_sectors/1
  # PATCH/PUT /sub_sectors/1.json
  def update
    respond_to do |format|
      if @sub_sector.update(sub_sector_params)
        format.html { redirect_to @sub_sector, notice: 'Sub sector was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_sector }
      else
        format.html { render :edit }
        format.json { render json: @sub_sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_sectors/1
  # DELETE /sub_sectors/1.json
  def destroy
    @sub_sector.destroy
    respond_to do |format|
      format.html { redirect_to sub_sectors_url, notice: 'Sub sector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_sector
      @sub_sector = SubSector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_sector_params
      params.require(:sub_sector).permit(:sector_id, :subsector_X, :subsector_Y)
    end
end
