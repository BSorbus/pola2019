class FinalDocumentationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: FinalDocumentationDatatable.new(params, view_context: view_context, final_documentionable_id: params[:final_documentionable_id], final_documentionable_type: params[:final_documentionable_type] ) }
    end
  end

  def download
    @final_documentation = FinalDocumentation.find(params[:id])
    final_documentation_authorize(@final_documentation, "show", @final_documentation.final_documentionable_type.singularize.downcase)

    send_file "#{@final_documentation.attached_file.path}", 
      type: "#{@final_documentation.file_content_type}",
      filename: @final_documentation.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /final_documentations/1
  # GET /final_documentations/1.json
  def show
    @final_documentation = FinalDocumentation.find(params[:id])
    final_documentation_authorize(@final_documentation, "show", @final_documentation.final_documentionable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /final_documentations/1/edit
  def edit
    @final_documentation = FinalDocumentation.find(params[:id])
    final_documentation_authorize(@final_documentation, "edit", @final_documentation.final_documentionable_type.singularize.downcase) 
  end

  # POST /final_documentations
  # POST /final_documentations.json
  def create
    @final_documentation = params[:final_documentation].present? ? @final_documentionable.final_documentations.new(final_documentation_params) : @final_documentionable.final_documentations.new()
    final_documentation_authorize(@final_documentation, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @final_documentation = @final_documentionable.final_documentations.create(final_documentation_params)
  end

  # PATCH/PUT /final_documentations/1
  # PATCH/PUT /final_documentations/1.json
  def update
    @final_documentation = FinalDocumentation.find(params[:id])
    @final_documentation.user = current_user
    final_documentation_authorize(@final_documentation, "update", @final_documentation.final_documentionable_type.singularize.downcase) 
    respond_to do |format|
      if @final_documentation.update(final_documentation_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @final_documentation.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @final_documentation.final_documentionable_type.pluralize.downcase, action: 'show', id: @final_documentation.final_documentionable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /final_documentations/1
  # DELETE /final_documentations/1.json
  def destroy
    @final_documentation = FinalDocumentation.find(params[:id])
    final_documentation_authorize(@final_documentation, "destroy", @final_documentation.final_documentionable_type.singularize.downcase)
    if @final_documentation.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def final_documentation_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def final_documentation_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:final_documentation).permit(:final_documentionable_id, :final_documentionable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def final_documentation_update_params
      params.require(:final_documentation).permit(:note, :user_id)
    end
end
