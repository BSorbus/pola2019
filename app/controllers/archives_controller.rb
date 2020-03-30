class ArchivesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index]
  before_action :set_archive, only: [:show, :edit, :update, :destroy]

  # GET /archives
  # GET /archives.json

  def datatables_index
    user_filter = (params[:eager_filter_for_current_user].blank? || params[:eager_filter_for_current_user] == 'false' ) ? nil : current_user.id
    respond_to do |format|
      format.json{ render json: ArchiveDatatable.new(params, eager_filter: user_filter ) }
    end
  end

  def index
    authorize :archive, :index?
    @archives = Archive.all
  end

  # GET /archives/1
  # GET /archives/1.json
  def show
    authorize @archive, :show?
  end

  # GET /archives/new
  def new
    @archive = Archive.new
    authorize @archive, :new?
  end

  # GET /archives/1/edit
  def edit
    authorize @archive, :edit?
  end

  # POST /archives
  # POST /archives.json
  def create
#    @event = Event.new(event_params_create)
    @archive = Archive.new(archive_params)
    @archive.user = current_user
    authorize @archive, :create?
    respond_to do |format|
      if @archive.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @archive.fullname)
        format.html { redirect_to @archive }
        format.json { render :show, status: :created, location: @archive }
      else
        format.html { render :new }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archives/1
  # PATCH/PUT /archives/1.json
  def update
    @archive.user = current_user
    authorize @archive, :update?
    respond_to do |format|
      if @archive.update(archive_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @archive.fullname)
        format.html { redirect_to @archive }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archives/1
  # DELETE /archives/1.json
  def destroy
    authorize @archive, :destroy?
    if @archive.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @archive.fullname)
      #@archive.log_work('destroy', current_user.id)
      redirect_to archives_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @archive.fullname)
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive
      @archive = Archive.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def archive_params
#      params.require(:archive).permit(:name, :note)

#      params.require(:archive).permit(policy(@archive).permitted_attributes)      
      params.require(:archive).permit(:name, :note, archivizations_attributes: [:id, :archives_id, :group_id, :archivization_type_id, :_destroy])
    end

#TODO
    def event_params
      #params.require(:event).permit(policy(@event).permitted_attributes)
    end

    def event_params_create
      #params.require(:event).permit(policy(:event).permitted_attributes)
    end    
end
