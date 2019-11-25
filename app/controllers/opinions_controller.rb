class OpinionsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: OpinionDatatable.new(params, view_context: view_context, opinionable_id: params[:opinionable_id], opinionable_type: params[:opinionable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsOpinionDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @opinion = Opinion.find(params[:id])
    opinion_authorize(@opinion, "show", @opinion.opinionable_type.singularize.downcase)

    send_file "#{@opinion.attached_file.path}", 
      type: "#{@opinion.file_content_type}",
      filename: @opinion.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /opinions/1
  # GET /opinions/1.json
  def show
    @opinion = Opinion.find(params[:id])
    opinion_authorize(@opinion, "show", @opinion.opinionable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show_through_events
    @opinion = Opinion.find(params[:id])
    opinion_authorize(@opinion, "show", @opinion.opinionable_type.singularize.downcase)

    respond_to do |format|
      format.js
    end
  end

  # GET /opinions/1/edit
  def edit
    @opinion = Opinion.find(params[:id])
    opinion_authorize(@opinion, "edit", @opinion.opinionable_type.singularize.downcase) 
  end

  # POST /opinions
  # POST /opinions.json
  def create
    @opinion = params[:opinion].present? ? @opinionable.opinions.new(opinion_params) : @opinionable.opinions.new()
    opinion_authorize(@opinion, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @opinion = @opinionable.opinions.create(opinion_params)
  end

  # PATCH/PUT /opinions/1
  # PATCH/PUT /opinions/1.json
  def update
    @opinion = Opinion.find(params[:id])
    @opinion.user = current_user
    opinion_authorize(@opinion, "update", @opinion.opinionable_type.singularize.downcase) 
    respond_to do |format|
      if @opinion.update(opinion_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @opinion.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @opinion.opinionable_type.pluralize.downcase, action: 'show', id: @opinion.opinionable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /opinions/1
  # DELETE /opinions/1.json
  def destroy
    @opinion = Opinion.find(params[:id])
    opinion_authorize(@opinion, "destroy", @opinion.opinionable_type.singularize.downcase)
    if @opinion.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def opinion_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def opinion_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:opinion).permit(:opinionable_id, :opinionable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def opinion_update_params
      params.require(:opinion).permit(:note, :user_id)
    end
end
