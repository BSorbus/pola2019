class CustomersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]


  def datatables_index
    user_filter = (params[:eager_filter_for_current_user].blank? || params[:eager_filter_for_current_user] == 'false' ) ? nil : current_user.id
    respond_to do |format|
      format.json{ render json: CustomerDatatable.new(params, eager_filter: user_filter) }
    end
  end

  def select2_index
    authorize :customer, :index?
    params[:q] = params[:q]
    @customers = Customer.order(:name).finder_customer(params[:q])
    @customers_on_page = @customers.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      customers: @customers_on_page.as_json(methods: :fullname, only: [:id, :fullname]),
      meta: { total_count: @customers.count }  
    } 
  end

  # GET /customers
  # GET /customers.json
  def index
    authorize :customer, :index?
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    authorize @customer, :show?
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    authorize @customer, :new?
  end

  # GET /customers/1/edit
  def edit
    authorize @customer, :edit?
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer.user = current_user
    authorize @customer, :create?
    respond_to do |format|
      if @customer.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @customer.fullname)
        format.html { redirect_to @customer }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    @customer.user = current_user
    authorize @customer, :update?
    respond_to do |format|
      if @customer.update(customer_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @customer.fullname)
        format.html { redirect_to @customer }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    # authorize @customer, :destroy?
    # @customer.destroy
    # respond_to do |format|
    #   format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
    authorize @customer, :destroy?
    if @customer.destroy
      flash[:success].new = t('activerecord.successfull.messages.destroyed', data: @customer.fullname)
      @customer.log_work('destroy', current_user.id)
      redirect_to customers_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @customer.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :nip, :regon, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :phone, :fax, :email, :epuap, :rpt, :note, :user_id)
    end
end
