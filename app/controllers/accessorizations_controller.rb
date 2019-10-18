class AccessorizationsController < ApplicationController
  before_action :authenticate_user!
  # after_action :verify_authorized


  # Events for showed user
  def datatables_index_user
    respond_to do |format|
      format.json{ render json: AccessorizationsDatatable.new(params, { only_for_current_user_id: params[:user_id] }) }
    end
  end

  # Events for showed role
  def datatables_index_role
    respond_to do |format|
      format.json{ render json: AccessorizationsDatatable.new(params, { only_for_current_role_id: params[:role_id] }) }
    end
  end

  # Events for showed errand
  def datatables_index_errand
    respond_to do |format|
      format.json{ render json: AccessorizationsDatatable.new(params, { only_for_current_errand_id: params[:errand_id] }) }
    end
  end

end
