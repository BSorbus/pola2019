class StatementsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: StatementDatatable.new(params, view_context: view_context, statemenable_id: params[:statemenable_id], statemenable_type: params[:statemenable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsStatementDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @statement = Statement.find(params[:id])
    statement_authorize(@statement, "show", @statement.statemenable_type.singularize.downcase)

    send_file "#{@statement.attached_file.path}", 
      type: "#{@statement.file_content_type}",
      filename: @statement.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /statements/1
  # GET /statements/1.json
  def show
    @statement = Statement.find(params[:id])
    statement_authorize(@statement, "show", @statement.statemenable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /statements/1/edit
  def edit
    @statement = Statement.find(params[:id])
    statement_authorize(@statement, "edit", @statement.statemenable_type.singularize.downcase) 
  end

  # POST /statements
  # POST /statements.json
  def create
    @statement = params[:statement].present? ? @statemenable.statements.new(statement_params) : @statemenable.statements.new()
    statement_authorize(@statement, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @statement = @statemenable.statements.create(statement_params)
  end

  # PATCH/PUT /statements/1
  # PATCH/PUT /statements/1.json
  def update
    @statement = Statement.find(params[:id])
    @statement.user = current_user
    statement_authorize(@statement, "update", @statement.statemenable_type.singularize.downcase) 
    respond_to do |format|
      if @statement.update(statement_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @statement.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @statement.statemenable_type.pluralize.downcase, action: 'show', id: @statement.statemenable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /statements/1
  # DELETE /statements/1.json
  def destroy
    @statement = Statement.find(params[:id])
    statement_authorize(@statement, "destroy", @statement.statemenable_type.singularize.downcase)
    if @statement.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def statement_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:statement).permit(:statemenable_id, :statemenable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def statement_update_params
      params.require(:statement).permit(:note, :user_id)
    end
end
