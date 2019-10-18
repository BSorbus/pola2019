class ZsPointsController < ApplicationController
  before_action :set_zs_point, only: [:show, :edit, :update, :destroy]

  # GET /zs_points
  # GET /zs_points.json
  def index
    @zs_points = ZsPoint.all
  end

  # GET /zs_points/1
  # GET /zs_points/1.json
  def show
  end

  # GET /zs_points/new
  def new
    @zs_point = ZsPoint.new
  end

  # GET /zs_points/1/edit
  def edit
  end

  # POST /zs_points
  # POST /zs_points.json
  def create
    @zs_point = ZsPoint.new(zs_point_params)

    respond_to do |format|
      if @zs_point.save
        format.html { redirect_to @zs_point, notice: 'Zs point was successfully created.' }
        format.json { render :show, status: :created, location: @zs_point }
      else
        format.html { render :new }
        format.json { render json: @zs_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zs_points/1
  # PATCH/PUT /zs_points/1.json
  def update
    respond_to do |format|
      if @zs_point.update(zs_point_params)
        format.html { redirect_to @zs_point, notice: 'Zs point was successfully updated.' }
        format.json { render :show, status: :ok, location: @zs_point }
      else
        format.html { render :edit }
        format.json { render json: @zs_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zs_points/1
  # DELETE /zs_points/1.json
  def destroy
    @zs_point.destroy
    respond_to do |format|
      format.html { redirect_to zs_points_url, notice: 'Zs point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zs_point
      @zs_point = ZsPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def zs_point_params
      params.require(:zs_point).permit(:point_file_id, :zs_2)
    end
end
