class InfosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: InfoDatatable.new(params, view_context: view_context, infoable_id: params[:infoable_id], infoable_type: params[:infoable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsInfoDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @info = Info.find(params[:id])
    info_authorize(@info, "show", @info.infoable_type.singularize.downcase)

    send_file "#{@info.attached_file.path}", 
      type: "#{@info.file_content_type}",
      filename: @info.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /infos/1
  # GET /infos/1.json
  def show
    @info = Info.find(params[:id])
    info_authorize(@info, "show", @info.infoable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /infos/1/edit
  def edit
    @info = Info.find(params[:id])
    info_authorize(@info, "edit", @info.infoable_type.singularize.downcase) 
  end

  # POST /infos
  # POST /infos.json
  def create
    @info = params[:info].present? ? @infoable.infos.new(info_params) : @infoable.infos.new()
    info_authorize(@info, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @info = @infoable.infos.create(info_params)
  end

  # PATCH/PUT /infos/1
  # PATCH/PUT /infos/1.json
  def update
    @info = Info.find(params[:id])
    @info.user = current_user
    info_authorize(@info, "update", @info.infoable_type.singularize.downcase) 
    respond_to do |format|
      if @info.update(info_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @info.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @info.infoable_type.pluralize.downcase, action: 'show', id: @info.infoable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /infos/1
  # DELETE /infos/1.json
  def destroy
    @info = Info.find(params[:id])
    info_authorize(@info, "destroy", @info.infoable_type.singularize.downcase)
    if @info.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def info_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def info_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:info).permit(:infoable_id, :infoable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def info_update_params
      params.require(:info).permit(:note, :user_id)
    end
end
