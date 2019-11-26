class ProtocolsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: ProtocolDatatable.new(params, view_context: view_context, protocolable_id: params[:protocolable_id], protocolable_type: params[:protocolable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsProtocolDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @protocol = Protocol.find(params[:id])
    protocol_authorize(@protocol, "show", @protocol.protocolable_type.singularize.downcase)

    send_file "#{@protocol.attached_file.path}", 
      type: "#{@protocol.file_content_type}",
      filename: @protocol.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /protocols/1
  # GET /protocols/1.json
  def show
    @protocol = Protocol.find(params[:id])
    protocol_authorize(@protocol, "show", @protocol.protocolable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /protocols/1/edit
  def edit
    @protocol = Protocol.find(params[:id])
    protocol_authorize(@protocol, "edit", @protocol.protocolable_type.singularize.downcase) 
  end

  # POST /protocols
  # POST /protocols.json
  def create
    @protocol = params[:protocol].present? ? @protocolable.protocols.new(protocol_params) : @protocolable.protocols.new()
    protocol_authorize(@protocol, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @protocol = @protocolable.protocols.create(protocol_params)
  end

  # PATCH/PUT /protocols/1
  # PATCH/PUT /protocols/1.json
  def update
    @protocol = Protocol.find(params[:id])
    @protocol.user = current_user
    protocol_authorize(@protocol, "update", @protocol.protocolable_type.singularize.downcase) 
    respond_to do |format|
      if @protocol.update(protocol_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @protocol.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @protocol.protocolable_type.pluralize.downcase, action: 'show', id: @protocol.protocolable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /protocols/1
  # DELETE /protocols/1.json
  def destroy
    @protocol = Protocol.find(params[:id])
    protocol_authorize(@protocol, "destroy", @protocol.protocolable_type.singularize.downcase)
    if @protocol.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def protocol_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def protocol_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:protocol).permit(:protocolable_id, :protocolable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def protocol_update_params
      params.require(:protocol).permit(:note, :user_id)
    end
end
