class MeasurementsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: MeasurementDatatable.new(params, view_context: view_context, measurementable_id: params[:measurementable_id], measurementable_type: params[:measurementable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsMeasurementDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @measurement = Measurement.find(params[:id])
    measurement_authorize(@measurement, "show", @measurement.measurementable_type.singularize.downcase)

    send_file "#{@measurement.attached_file.path}", 
      type: "#{@measurement.file_content_type}",
      filename: @measurement.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /measurements/1
  # GET /measurements/1.json
  def show
    @measurement = Measurement.find(params[:id])
    measurement_authorize(@measurement, "show", @measurement.measurementable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /measurements/1/edit
  def edit
    @measurement = Measurement.find(params[:id])
    measurement_authorize(@measurement, "edit", @measurement.measurementable_type.singularize.downcase) 
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @measurement = params[:measurement].present? ? @measurementable.measurements.new(measurement_params) : @measurementable.measurements.new()
    measurement_authorize(@measurement, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @measurement = @measurementable.measurements.create(measurement_params)
  end

  # PATCH/PUT /measurements/1
  # PATCH/PUT /measurements/1.json
  def update
    @measurement = Measurement.find(params[:id])
    @measurement.user = current_user
    measurement_authorize(@measurement, "update", @measurement.measurementable_type.singularize.downcase) 
    respond_to do |format|
      if @measurement.update(measurement_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @measurement.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @measurement.measurementable_type.pluralize.downcase, action: 'show', id: @measurement.measurementable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @measurement = Measurement.find(params[:id])
    measurement_authorize(@measurement, "destroy", @measurement.measurementable_type.singularize.downcase)
    if @measurement.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def measurement_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def measurement_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:measurement).permit(:measurementable_id, :measurementable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def measurement_update_params
      params.require(:measurement).permit(:note, :user_id)
    end
end
