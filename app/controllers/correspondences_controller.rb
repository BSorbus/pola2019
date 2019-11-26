class CorrespondencesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: CorrespondenceDatatable.new(params, view_context: view_context, correspondenable_id: params[:correspondenable_id], correspondenable_type: params[:correspondenable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsCorrespondenceDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @correspondence = Correspondence.find(params[:id])
    correspondence_authorize(@correspondence, "show", @correspondence.correspondenable_type.singularize.downcase)

    send_file "#{@correspondence.attached_file.path}", 
      type: "#{@correspondence.file_content_type}",
      filename: @correspondence.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /correspondences/1
  # GET /correspondences/1.json
  def show
    @correspondence = Correspondence.find(params[:id])
    correspondence_authorize(@correspondence, "show", @correspondence.correspondenable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /correspondences/1/edit
  def edit
    @correspondence = Correspondence.find(params[:id])
    correspondence_authorize(@correspondence, "edit", @correspondence.correspondenable_type.singularize.downcase) 
  end

  # POST /correspondences
  # POST /correspondences.json
  def create
    @correspondence = params[:correspondence].present? ? @correspondenable.correspondences.new(correspondence_params) : @correspondenable.correspondences.new()
    correspondence_authorize(@correspondence, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @correspondence = @correspondenable.correspondences.create(correspondence_params)
  end

  # PATCH/PUT /correspondences/1
  # PATCH/PUT /correspondences/1.json
  def update
    @correspondence = Correspondence.find(params[:id])
    @correspondence.user = current_user
    correspondence_authorize(@correspondence, "update", @correspondence.correspondenable_type.singularize.downcase) 
    respond_to do |format|
      if @correspondence.update(correspondence_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @correspondence.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @correspondence.correspondenable_type.pluralize.downcase, action: 'show', id: @correspondence.correspondenable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /correspondences/1
  # DELETE /correspondences/1.json
  def destroy
    @correspondence = Correspondence.find(params[:id])
    correspondence_authorize(@correspondence, "destroy", @correspondence.correspondenable_type.singularize.downcase)
    if @correspondence.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def correspondence_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def correspondence_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:correspondence).permit(:correspondenable_id, :correspondenable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def correspondence_update_params
      params.require(:correspondence).permit(:note, :user_id)
    end
end
