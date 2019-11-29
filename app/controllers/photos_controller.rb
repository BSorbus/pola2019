class PhotosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:show, :edit, :update, :create, :destroy]

  def datatables_index
    respond_to do |format|
      format.json{ render json: PhotoDatatable.new(params, view_context: view_context, photoable_id: params[:photoable_id], photoable_type: params[:photoable_type] ) }
    end
  end

  def datatables_index_through_events
    respond_to do |format|
      format.json{ render json: ThroughEventsPhotoDatatable.new(params, view_context: view_context, for_parent_id: params[:for_parent_id], for_parent_type: params[:for_parent_type] ) }
    end
  end

  def download
    @photo = Photo.find(params[:id])
    photo_authorize(@photo, "show", @photo.photoable_type.singularize.downcase)

    send_file "#{@photo.attached_file.path}", 
      type: "#{@photo.file_content_type}",
      filename: @photo.attached_file.file.filename, 
      dispostion: "inline", 
      status: 200, 
      stream: true, 
      x_sendfile: true    
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])
    photo_authorize(@photo, "show", @photo.photoable_type.singularize.downcase)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
    photo_authorize(@photo, "edit", @photo.photoable_type.singularize.downcase) 
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = params[:photo].present? ? @photoable.photos.new(photo_params) : @photoable.photos.new()
    photo_authorize(@photo, "create", params[:controller].classify.deconstantize.singularize.downcase)

    @photo = @photoable.photos.create(photo_params)
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])
    @photo.user = current_user
    photo_authorize(@photo, "update", @photo.photoable_type.singularize.downcase) 
    respond_to do |format|
      if @photo.update(photo_update_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @photo.fullname)
        format.html { redirect_to url_for(only_path: true, controller: @photo.photoable_type.pluralize.downcase, action: 'show', id: @photo.photoable.id) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    photo_authorize(@photo, "destroy", @photo.photoable_type.singularize.downcase)
    if @photo.destroy_and_log_work(current_user.id)
      head :no_content
    end
  end

  private
    def photo_authorize(model_class, action, sub_controller)
      unless ['index', 'show', 'edit', 'create', 'update', 'destroy'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{sub_controller}_#{action}?"      
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      defaults = { user_id: "#{current_user.id}" }
      params.require(:photo).permit(:photoable_id, :photoable_type, :attached_file, :note, :user_id, :latitude, :longitude ).reverse_merge(defaults)
    end
    def photo_update_params
      params.require(:photo).permit(:note, :user_id, :latitude, :longitude)
    end
end
