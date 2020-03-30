class GroupsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index, :datatables_index_user]
  before_action :set_group, only: [:show, :edit, :update, :destroy]


  def datatables_index_user
    respond_to do |format|
      format.json{ render json: UserGroupsDatatable.new(params, view_context: view_context, only_for_current_user_id: params[:user_id]) }
    end
  end

  def select2_index
    authorize :group, :index?
    params[:q] = params[:q]
    @groups = Group.order(:name).finder_group(params[:q])
    @groups_on_page = @groups.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      groups: @groups_on_page.as_json(methods: :fullname, only: [:id, :fullname]),
      meta: { total_count: @groups.count }  
    } 
  end

  def datatables_index
    respond_to do |format|
      format.json{ render json: GroupDatatable.new(params) }
    end
  end

  # GET /groups
  # GET /groups.json
  def index
    authorize :group, :index?
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize @group, :show?
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group, :new?
  end

  # GET /groups/1/edit
  def edit
    authorize @group, :edit?
  end

  # POST /groups
  # POST /groups.json
  def create
    # @group = Group.new(name: params[:group][:name], note: params[:group][:note], special: params[:group][:special],activities: params[:group][:activities].split)
    @group = Group.new(group_params)
    authorize @group, :create?
    respond_to do |format|
      if @group.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @group.fullname)
        format.html { redirect_to @group }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize @group, :update?
    respond_to do |format|
      # if @group.update(name: params[:group][:name], note: params[:group][:note], special: params[:group][:special],activities: params[:group][:activities].split)
      if @group.update(group_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @group.fullname)
        format.html { redirect_to @group }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    # @group.destroy
    # respond_to do |format|
    #   flash[:success] = "Group destroyed!"
    #   format.html { redirect_to groups_url }
    #   format.json { head :no_content }
    # end
    authorize @group, :destroy?
    if @group.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @group.fullname)
      redirect_to groups_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @group.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :note, :user_id)
    end
end
