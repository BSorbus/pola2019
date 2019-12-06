class ProjectsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index, :datatables_index_customer, :show_charts]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_proposal_file, only: [:show]
  before_action :set_point_file, only: [:show]


  def show_charts
    respond_to do |format|
      format.html{ render 'charts/show_charts' }
    end
  end

  def send_status
    project = Project.find(params[:id])
    params[:users_ids].each do |i|
      user = User.find(i)
      StatusMailer.project_status_email(user, project).deliver_now
    end
    #flash[:success] = t('activerecord.successfull.messages.created', data: @project.fullname)
    redirect_to project, notice: "Email status about \"#{project.number}\" was successfully sent."
  end

  def datatables_index_customer
    respond_to do |format|
      format.json{ render json: ProjectDatatable.new(params, { only_for_current_customer_id: params[:customer_id] }) }
    end
  end

  def datatables_index
    user_filter = (params[:eager_filter_for_current_user].blank? || params[:eager_filter_for_current_user] == 'false' ) ? nil : current_user.id
    respond_to do |format|
      format.json{ render json: ProjectDatatable.new(params, eager_filter: user_filter) }
    end
  end

  def select2_index
    authorize :project, :index?
    params[:q] = params[:q]
    @projects = Project.order(:number).finder_project(params[:q])
    @projects_on_page = @projects.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      projects: @projects_on_page.as_json(methods: :fullname, only: [:id, :fullname]),
      meta: { total_count: @projects.count }  
    } 
  end

  # GET /projects
  # GET /projects.json
  def index
    authorize :project, :index?
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    authorize @project, :show?
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project, :new?
  end

  # GET /projects/1/edit
  def edit
    authorize @project, :edit?
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user
    authorize @project, :create?
    respond_to do |format|
      if @project.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @project.fullname)
        format.html { redirect_to @project }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project.user = current_user
    authorize @project, :update?
    respond_to do |format|
      if @project.update(project_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @project.fullname)
        format.html { redirect_to @project }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    # authorize @project, :destroy?
    # @project.destroy
    # respond_to do |format|
    #   flash[:success] = "Project destroyed!"
    #   format.html { redirect_to projects_url }
    #   format.json { head :no_content }
    # end
    authorize @project, :destroy?
    if @project.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @project.fullname)
      @project.log_work('destroy', current_user.id)
      redirect_to projects_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @project.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_proposal_file
      @proposal_file = @project.last_active_proposal_file
    end

    def set_point_file
      @point_file = @project.last_active_point_file
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:number, :registration, :note, :project_status_id, :enrollment_id, :area_id, :area_name, :customer_id, :users_id)
    end

end
