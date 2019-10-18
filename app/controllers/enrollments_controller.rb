class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index]
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]

  # GET /enrollments
  # GET /enrollments.json
  def index
    authorize :enrollment, :index?
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1
  # GET /enrollments/1.json
  def show
    authorize @enrollment, :show?
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
    authorize @enrollment, :new?
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment, :edit?
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.user = current_user
    authorize @enrollment, :create?
    respond_to do |format|
      if @enrollment.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @enrollment.fullname)
        format.html { redirect_to @enrollment }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    @enrollment.user = current_user
    authorize @enrollment, :update?
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @enrollment.fullname)
        format.html { redirect_to @enrollment }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1
  # DELETE /enrollments/1.json
  def destroy
    authorize @enrollment, :destroy?
    if @enrollment.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @enrollment.fullname)
      @enrollment.log_work('destroy', current_user.id)
      redirect_to enrollments_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @enrollment.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enrollment_params
      params.require(:enrollment).permit(:name, :note, :user_id)
    end
end
