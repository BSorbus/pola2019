class Projects::ProposalFilesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_project, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_proposal_file, only: [:download, :show, :edit, :update, :destroy]



  def download
    authorize @proposal_file, :download?
    send_file "#{@proposal_file.load_file.file.file}", 
      type: "#{@proposal_file.load_file.file.content_type}",
      x_sendfile: true
  end

  # GET /proposal_files/1
  # GET /proposal_files/1.json
  def show
    authorize @proposal_file, :show?
  end

  # GET /proposal_files/new
  def new
    @proposal_file = ProposalFile.new
    @proposal_file.project = @project
    @proposal_file.load_date = Time.zone.now 
    @proposal_file.status = :active 
    authorize @proposal_file, :new?
  end

  # GET /proposal_files/1/edit
  def edit
    authorize @proposal_file, :edit?
  end

  # POST /proposal_files
  # POST /proposal_files.json
  def create
    @proposal_file = ProposalFile.new(proposal_file_params)
    @proposal_file.project = @project
    authorize @proposal_file, :create?
    respond_to do |format|
      if @proposal_file.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @proposal_file.fullname)
        @proposal_file.load_data_from_xml_file
        format.html { redirect_to project_proposal_file_path(@project, @proposal_file) }
        format.json { render :show, status: :created, location: @proposal_file }
      else
        format.html { render :new }
        format.json { render json: @proposal_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proposal_files/1
  # PATCH/PUT /proposal_files/1.json
  def update
    authorize @proposal_file, :update?
    respond_to do |format|
      if @proposal_file.update(proposal_file_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @proposal_file.fullname)
        format.html { redirect_to project_proposal_file_path(@project, @proposal_file) }
        format.json { render :show, status: :ok, location: @proposal_file }
      else
        format.html { render :edit }
        format.json { render json: @proposal_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposal_files/1
  # DELETE /proposal_files/1.json
  def destroy
    authorize @proposal_file, :destroy?
    if @proposal_file.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @proposal_file.fullname)
      redirect_to project_path(@project)
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @proposal_file.fullname)
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal_file
      @proposal_file = ProposalFile.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_file_params
      params.require(:proposal_file).permit(:project_id, :load_date, :load_file, :load_file_cache, :status, :note)
    end
end
