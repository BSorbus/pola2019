class WwPointsController < ApplicationController
  before_action :set_ww_point, only: [:show, :edit, :update, :destroy]

  # GET /ww_points
  # GET /ww_points.json
  def index
    @ww_points = WwPoint.all
  end

  # GET /ww_points/1
  # GET /ww_points/1.json
  def show
  end

  # GET /ww_points/new
  def new
    @ww_point = WwPoint.new
  end

  # GET /ww_points/1/edit
  def edit
  end

  # POST /ww_points
  # POST /ww_points.json
  def create
    @ww_point = WwPoint.new(ww_point_params)

    respond_to do |format|
      if @ww_point.save
        format.html { redirect_to @ww_point, notice: 'Ww point was successfully created.' }
        format.json { render :show, status: :created, location: @ww_point }
      else
        format.html { render :new }
        format.json { render json: @ww_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ww_points/1
  # PATCH/PUT /ww_points/1.json
  def update
    respond_to do |format|
      if @ww_point.update(ww_point_params)
        format.html { redirect_to @ww_point, notice: 'Ww point was successfully updated.' }
        format.json { render :show, status: :ok, location: @ww_point }
      else
        format.html { render :edit }
        format.json { render json: @ww_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ww_points/1
  # DELETE /ww_points/1.json
  def destroy
    @ww_point.destroy
    respond_to do |format|
      format.html { redirect_to ww_points_url, notice: 'Ww point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ww_point
      @ww_point = WwPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ww_point_params
      params.require(:ww_point).permit(:point_file_id, :ww_2)
    end
end
