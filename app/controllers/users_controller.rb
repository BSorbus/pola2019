class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index_role, :datatables_index_group, :datatables_index]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :account_off, :account_on, :set_activity_at]


  def datatables_index_role
    respond_to do |format|
      format.json{ render json: RoleUsersDatatable.new(params, view_context: view_context, only_for_current_role_id: params[:role_id]) }
    end
  end

  def datatables_index_group
    respond_to do |format|
      format.json{ render json: GroupUsersDatatable.new(params, view_context: view_context, only_for_current_group_id: params[:group_id]) }
    end
  end

  def datatables_index
    respond_to do |format|
      format.json{ render json: UserDatatable.new(params) }
    end
  end

  def select2_index
    authorize :user, :index?
    #params[:q] = (params[:q]).upcase
    params[:q] = params[:q]
    @users = User.order(:name).finder_user(params[:q])
    @users_on_page = @users.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      users: @users_on_page.as_json(methods: :fullname, only: [:id, :fullname]),
      meta: { total_count: @users.count }  
    } 
  end

  # GET /users
  # GET /users.json
  def index
    authorize :user, :index?
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user, :show?
  end

  # GET /users/new
  def new
    @user = User.new
    authorize @user, :new?
  end

  # GET /users/1/edit
  def edit
    authorize @user, :edit?
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    authorize @user, :create?
    respond_to do |format|
      if @user.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @user.fullname)
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user, :update?
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @user.fullname)
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # @user.destroy
    # respond_to do |format|
    #   flash[:success] = "User destroyed!"
    #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
    authorize @user, :destroy?
    if @user.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @user.fullname)
      redirect_to users_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @user.fullname)
      #redirect_to :back
      render :show
    end      
  end

  def account_off
    authorize @user, :update?

    @user.soft_delete
    if @user.save
      flash[:success] = t('activerecord.successfull.messages.account_off', data: @user.fullname)
      redirect_to @user
    else 
      flash.now[:error] = t('activerecord.errors.messages.account_off', data: @user.fullname)
      render :show 
    end         
  end

  def account_on
    authorize @user, :update?

    @user.deleted_at = nil
    if @user.save
      flash[:success] = t('activerecord.successfull.messages.account_on', data: @user.fullname)
      redirect_to @user
    else 
      flash.now[:error] = t('activerecord.errors.messages.account_on', data: @user.fullname)
      render :show 
    end         
  end

  def set_activity_at
    authorize @user, :update?

    @user.last_activity_at = Time.zone.now - 1.month
    if @user.save
      flash[:success] = t('activerecord.successfull.messages.set_activity_at', data: @user.fullname)
      redirect_to @user
    else 
      flash.now[:error] = t('activerecord.errors.messages.set_activity_at', data: @user.fullname)
      render :show 
    end         
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :legitimation, :position, :notification_by_email, :note)
    end
end