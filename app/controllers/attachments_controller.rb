require 'zip_file_generator'

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :create_folder, :destroy]
  before_action :set_attachment, only: [:download, :show, :edit, :update, :destroy, :move_to_photo]

  def datatables_index
#    attachment_parent_filter = params[:attachment_parent_id].present? ? params[:attachment_parent_id] : nil
    respond_to do |format|
      format.json{ render json: AttachmentDatatable.new(params, view_context: view_context, 
        attachmenable_id: params[:attachmenable_id], 
        attachmenable_type: params[:attachmenable_type],
        attachment_parent_filter: params[:attachment_parent_id] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsAttachmentDatatable.new(params, view_context: view_context, 
        for_parent_id: params[:for_parent_id], 
        for_parent_type: params[:for_parent_type],
        attachment_parent_filter: params[:attachment_parent_id] ) }
    end
  end

  def download
#    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "show", @attachment.attachmenable_type.singularize.downcase)

    @attachment.log_work('download_attachment', current_user.id)

    send_file "#{@attachment.attached_file.path}", 
      type: "#{@attachment.file_content_type}",
      filename: @attachment.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  def zip_and_download
#    attachment_authorize(@attachment, "show", @attachment.attachmenable_type.singularize.downcase)

    attachment_ids = params[:attachment_ids].present? ? params[:attachment_ids] : []
 
    # create directory and copy file
    pr = PreparationForZipFileGenerator.new('Attachment', 'attached_file', 'file', attachment_ids)
    pr.copy_files_to_tmp
    # ziped directory
    zf = ZipFileGenerator.new(pr.root_dir_to_zip, pr.out_zip_file)
    zf.write()

    # remove tmp folder
    pr.delete_tmp_directory

    attachment_ids.each do |id|
      attachment = Attachment.find(id)
      attachment.log_work('download_attachment', current_user.id)
    end

    respond_to do |format|
      format.zip {  
                    send_file "#{pr.out_zip_file}", 
                      filename: "#{pr.output_file_name}", 
                      dispostion: "inline", 
                      status: 200, 
                      stream: true, 
                      x_sendfile: true
                  }
    end
  end


  # GET /attachments/1
  # GET /attachments/1.json
  def show
#    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "show", @attachment.attachmenable_type.singularize.downcase)

    respond_to do |format|
      format.html {redirect_to @attachment.attachmenable }
      format.js
    end
  end

  # GET /attachments/1/edit
  def edit
#    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "edit", @attachment.attachmenable_type.singularize.downcase) 
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = params[:attachment].present? ? @attachmenable.attachments.new(attachment_params) : @attachmenable.attachments.new()
    attachment_authorize(@attachment, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @attachment = @attachmenable.attachments.create(attachment_params)
    @attachment.log_work('upload_attachment', current_user.id) if @attachment.errors.empty?
  end

  def create_folder
    @attachment = params[:attachment].present? ? @attachmenable.attachments.new(attachment_params_for_folder) : @attachmenable.attachments.new()
    attachment_authorize(@attachment, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @attachment = @attachmenable.attachments.create(attachment_params_for_folder)
    @attachment.log_work('create_directory', current_user.id) if @attachment.errors.empty?

    respond_to do |format|
      format.js  { render status: :created, layout: false, file: 'attachments/create_folder.js.erb' }
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
#    @attachment = Attachment.find(params[:id])
    @attachment.user = current_user
    attachment_authorize(@attachment, "update", @attachment.attachmenable_type.singularize.downcase) 
    respond_to do |format|
      if @attachment.update(attachment_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @attachment.fullname)
        @attachment.log_work('update_attachment', current_user.id)
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
#    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "destroy", @attachment.attachmenable_type.singularize.downcase)
    if @attachment.destroy_and_log_work(current_user.id)
      #flash.now[:success] = t('activerecord.successfull.messages.destroyed', data: @attachment.fullname)
      head :no_content
    end
  end

  def move_to_photo
#    @attachment = Attachment.find(params[:id])
    attachment_authorize(@attachment, "destroy", @attachment.attachmenable_type.singularize.downcase)
    if @attachment.move_to_photo_and_log_work(current_user.id)
      head :no_content
    end 
  end

  def move_to_parent
#    attachment_authorize(@attachment, "update", @attachment.attachmenable_type.singularize.downcase)
    errors = Attachment::move_to_parent_and_log_work(params[:parent_id], params[:children_ids], current_user.id)

    if errors.blank?
      head :ok
    else
      errors_msgs = ""    

      errors.each do |msg|
        errors_msgs += msg.full_messages.join(', ').force_encoding("UTF-8")
      end

      render status: :conflict, json: { "errors": "#{errors_msgs}" }

      # respond_to do |format|
      #   # that will mean to send a javascript code to client-side;
      #   format.js { render             
      #       # raw javascript to be executed on client-side
      #       "alert('Hello Rails');", 
      #       # send HTTP response code on header
      #       :status => 404, # page not found
      #       # load /app/views/your-controller/different_action.js.erb
      #       :action => "different_action",
      #       # send json file with @line_item variable as json
      #       :json => { errors: "#{errors_msgs}" },
      #       :file => filename,
      #       :text => "#{errors_msgs}",
      #       # the :location option to set the HTTP Location header
      #       :location => path_to_controller_method_url(argument)
      #     }

      # end



    end 
  end

  private
    def attachment_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:attachment).permit(:attachmenable_id, :attachmenable_type, :attached_file, :note, :user_id, :parent_id ).reverse_merge(defaults)
    end
    def attachment_params_for_folder
      defaults = { user_id: "#{current_user.id}" }
      params.require(:attachment).permit(:attachmenable_id, :attachmenable_type, :name_if_folder, :note, :user_id, :parent_id ).reverse_merge(defaults)
    end
    def attachment_update_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:attachment).permit(:name_if_folder, :note, :user_id, :parent_id).reverse_merge(defaults)
    end
end
