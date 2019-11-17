class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy, :move_to_correspondence]

  def datatables_index
    respond_to do |format|
      format.json{ render json: AttachmentDatatable.new(params, view_context: view_context, attachmenable_id: params[:attachmenable_id], attachmenable_type: params[:attachmenable_type] ) }
    end
  end

  def download
    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "show", @attachment.attachmenable_type.singularize.downcase)

    send_file "#{@attachment.attached_file.path}", 
      type: "#{@attachment.file_content_type}",
      filename: @attachment.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "show", @attachment.attachmenable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end

  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "edit", @attachment.attachmenable_type.singularize.downcase) 
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = params[:attachment].present? ? @attachmenable.attachments.new(attachment_params) : @attachmenable.attachments.new()
    attachment_authorize(@attachment, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @attachment = @attachmenable.attachments.create(attachment_params)
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])
    @attachment.user = current_user
    attachment_authorize(@attachment, "update", @attachment.attachmenable_type.singularize.downcase) 
    respond_to do |format|
      if @attachment.update(attachment_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @attachment.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @attachment.attachmenable_type.pluralize.downcase, action: 'show', id: @attachment.attachmenable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    # @attachment = Attachment.find(params[:id])
    # attachment_authorize(@attachment, "destroy", @attachment.attachmenable_type.singularize.downcase)    
    # if @attachment.destroy
    #   flash[:success] = t('activerecord.successfull.messages.destroyed', data: @attachment.fullname)
    #   @attachment.log_work('destroy_attachment', current_user.id)
    #   redirect_to @attachment.attachmenable
    # else 
    #   flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @attachment.fullname)
    #   render :show
    # end      
    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "destroy", @attachment.attachmenable_type.singularize.downcase)
    if @attachment.destroy_and_log_work(current_user.id)
      #flash.now[:success] = t('activerecord.successfull.messages.destroyed', data: @attachment.fullname)
      head :no_content
    end
  end

  def move_to_correspondence
    puts '##################################### move_to_correspondence ##################################### '
    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "destroy", @attachment.attachmenable_type.singularize.downcase)
 
    if @attachment.move_to_correspondence_and_log_work(current_user.id)
      head :no_content
    end
 
  end

  private
    def attachment_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:attachment).permit(:attachmenable_id, :attachmenable_type, :attached_file, :note, :user_id ).reverse_merge(defaults)
    end
    def attachment_update_params
      params.require(:attachment).permit(:note, :user_id)
    end
end
