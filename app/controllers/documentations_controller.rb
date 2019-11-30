class DocumentationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: DocumentationDatatable.new(params, view_context: view_context, documentationable_id: params[:documentationable_id], documentationable_type: params[:documentationable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsDocumentationDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @documentation = Documentation.find(params[:id])
    documentation_authorize(@documentation, "show", @documentation.documentationable_type.singularize.downcase)

    send_file "#{@documentation.attached_file.path}", 
      type: "#{@documentation.file_content_type}",
      filename: @documentation.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /documentations/1
  # GET /documentations/1.json
  def show
    @documentation = Documentation.find(params[:id])
    documentation_authorize(@documentation, "show", @documentation.documentationable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /documentations/1/edit
  def edit
    @documentation = Documentation.find(params[:id])
    documentation_authorize(@documentation, "edit", @documentation.documentationable_type.singularize.downcase) 
  end

  # POST /documentations
  # POST /documentations.json
  def create
    @documentation = params[:documentation].present? ? @documentationable.documentations.new(documentation_params) : @documentationable.documentations.new()
    documentation_authorize(@documentation, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @documentation = @documentationable.documentations.create(documentation_params)
  end

  # PATCH/PUT /documentations/1
  # PATCH/PUT /documentations/1.json
  def update
    @documentation = Documentation.find(params[:id])
    @documentation.user = current_user
    documentation_authorize(@documentation, "update", @documentation.documentationable_type.singularize.downcase) 
    respond_to do |format|
      if @documentation.update(documentation_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @documentation.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @documentation.documentationable_type.pluralize.downcase, action: 'show', id: @documentation.documentationable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /documentations/1
  # DELETE /documentations/1.json
  def destroy
    @documentation = Documentation.find(params[:id])
    documentation_authorize(@documentation, "destroy", @documentation.documentationable_type.singularize.downcase)
    if @documentation.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def documentation_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def documentation_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:documentation).permit(:documentationable_id, :documentationable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def documentation_update_params
      params.require(:documentation).permit(:note, :user_id)
    end
end
