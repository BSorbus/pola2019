class ErrandsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index, :show_charts]
  before_action :set_errand, only: [:show, :edit, :update, :destroy]

  def show_charts
    respond_to do |format|
      format.html{ render 'charts/show_charts' }
    end
  end

  def datatables_index
    respond_to do |format|
      format.json{ render json: ErrandDatatable.new(params) }
    end
  end

  def select2_index
    authorize :errand, :index?
    params[:q] = params[:q]
    @errands = Errand.order(:number).finder_errand(params[:q])
    @errands_on_page = @errands.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      errands: @errands_on_page.as_json(methods: :fullname, only: [:id, :fullname]),
      meta: { total_count: @errands.count }  
    } 
  end

  # GET /errands
  # GET /errands.json
  def index
    authorize :errand, :index?
  end

  # GET /errands/1
  # GET /errands/1.json
  def show
    authorize @errand, :show?
  end

  # GET /errands/new
  def new
    @errand = Errand.new
    authorize @errand, :new?
  end

  # GET /errands/1/edit
  def edit
    authorize @errand, :edit?
  end

  # POST /errands
  # POST /errands.json
  def create
    @errand = Errand.new(errand_params)
    @errand.user = current_user
    authorize @errand, :create?
    respond_to do |format|
      if @errand.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @errand.fullname)
        format.html { redirect_to @errand }
        format.json { render :show, status: :created, location: @errand }
      else
        format.html { render :new }
        format.json { render json: @errand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /errands/1
  # PATCH/PUT /errands/1.json
  def update
    @errand.user = current_user
    authorize @errand, :update?
    respond_to do |format|
      if @errand.update(errand_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @errand.fullname)
        format.html { redirect_to @errand }
        format.json { render :show, status: :ok, location: @errand }
      else
        format.html { render :edit }
        format.json { render json: @errand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /errands/1
  # DELETE /errands/1.json
  def destroy
    authorize @errand, :destroy?
    if @errand.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @errand.fullname)
      @errand.log_work('destroy', current_user.id)
      redirect_to errands_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @errand.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_errand
      @errand = Errand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def errand_params
      params.require(:errand).permit(:number, :principal, :errand_status_id, :order_date, :adoption_date, :start_date, :end_date, :note, :user_id)
    end
end
