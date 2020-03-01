class OriginalDocumentationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: OriginalDocumentationDatatable.new(params, view_context: view_context, original_documentionable_id: params[:original_documentionable_id], original_documentionable_type: params[:original_documentionable_type] ) }
    end
  end

  def download
    @original_documentation = OriginalDocumentation.find(params[:id])
    original_documentation_authorize(@original_documentation, "show", @original_documentation.original_documentionable_type.singularize.downcase)

    send_file "#{@original_documentation.attached_file.path}", 
      type: "#{@original_documentation.file_content_type}",
      filename: @original_documentation.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /original_documentations/1
  # GET /original_documentations/1.json
  def show
    @original_documentation = OriginalDocumentation.find(params[:id])
    original_documentation_authorize(@original_documentation, "show", @original_documentation.original_documentionable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /original_documentations/1/edit
  def edit
    @original_documentation = OriginalDocumentation.find(params[:id])
    original_documentation_authorize(@original_documentation, "edit", @original_documentation.original_documentionable_type.singularize.downcase) 
  end

  # POST /original_documentations
  # POST /original_documentations.json
  def create
    @original_documentation = params[:original_documentation].present? ? @original_documentionable.original_documentations.new(original_documentation_params) : @original_documentionable.original_documentations.new()
    original_documentation_authorize(@original_documentation, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @original_documentation = @original_documentionable.original_documentations.create(original_documentation_params)
  end

  # PATCH/PUT /original_documentations/1
  # PATCH/PUT /original_documentations/1.json
  def update
    @original_documentation = OriginalDocumentation.find(params[:id])
    @original_documentation.user = current_user
    original_documentation_authorize(@original_documentation, "update", @original_documentation.original_documentionable_type.singularize.downcase) 
    respond_to do |format|
      if @original_documentation.update(original_documentation_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @original_documentation.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @original_documentation.original_documentionable_type.pluralize.downcase, action: 'show', id: @original_documentation.original_documentionable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /original_documentations/1
  # DELETE /original_documentations/1.json
  def destroy
    @original_documentation = OriginalDocumentation.find(params[:id])
    original_documentation_authorize(@original_documentation, "destroy", @original_documentation.original_documentionable_type.singularize.downcase)
    if @original_documentation.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def original_documentation_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def original_documentation_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:original_documentation).permit(:original_documentionable_id, :original_documentionable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def original_documentation_update_params
      params.require(:original_documentation).permit(:note, :user_id)
    end
end
