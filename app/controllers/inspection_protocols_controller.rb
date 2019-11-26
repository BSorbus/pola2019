class InspectionProtocolsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: InspectionProtocolDatatable.new(params, view_context: view_context, inspectionable_id: params[:inspectionable_id], inspectionable_type: params[:inspectionable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsInspectionProtocolDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @inspection_protocol = InspectionProtocol.find(params[:id])
    inspection_protocol_authorize(@inspection_protocol, "show", @inspection_protocol.inspectionable_type.singularize.downcase)

    send_file "#{@inspection_protocol.attached_file.path}", 
      type: "#{@inspection_protocol.file_content_type}",
      filename: @inspection_protocol.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /inspection_protocols/1
  # GET /inspection_protocols/1.json
  def show
    @inspection_protocol = InspectionProtocol.find(params[:id])
    inspection_protocol_authorize(@inspection_protocol, "show", @inspection_protocol.inspectionable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show_through_events
    @inspection_protocol = InspectionProtocol.find(params[:id])
    inspection_protocol_authorize(@inspection_protocol, "show", @inspection_protocol.inspectionable_type.singularize.downcase)

    respond_to do |format|
      format.js
    end
  end

  # GET /inspection_protocols/1/edit
  def edit
    @inspection_protocol = InspectionProtocol.find(params[:id])
    inspection_protocol_authorize(@inspection_protocol, "edit", @inspection_protocol.inspectionable_type.singularize.downcase) 
  end

  # POST /inspection_protocols
  # POST /inspection_protocols.json
  def create
    @inspection_protocol = params[:inspection_protocol].present? ? @inspectionable.inspection_protocols.new(inspection_protocol_params) : @inspectionable.inspection_protocols.new()
    inspection_protocol_authorize(@inspection_protocol, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @inspection_protocol = @inspectionable.inspection_protocols.create(inspection_protocol_params)
  end

  # PATCH/PUT /inspection_protocols/1
  # PATCH/PUT /inspection_protocols/1.json
  def update
    @inspection_protocol = InspectionProtocol.find(params[:id])
    @inspection_protocol.user = current_user
    inspection_protocol_authorize(@inspection_protocol, "update", @inspection_protocol.inspectionable_type.singularize.downcase) 
    respond_to do |format|
      if @inspection_protocol.update(inspection_protocol_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @inspection_protocol.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @inspection_protocol.inspectionable_type.pluralize.downcase, action: 'show', id: @inspection_protocol.inspectionable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /inspection_protocols/1
  # DELETE /inspection_protocols/1.json
  def destroy
    @inspection_protocol = InspectionProtocol.find(params[:id])
    inspection_protocol_authorize(@inspection_protocol, "destroy", @inspection_protocol.inspectionable_type.singularize.downcase)
    if @inspection_protocol.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def inspection_protocol_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def inspection_protocol_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:inspection_protocol).permit(:inspectionable_id, :inspectionable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def inspection_protocol_update_params
      params.require(:inspection_protocol).permit(:note, :user_id)
    end
end
