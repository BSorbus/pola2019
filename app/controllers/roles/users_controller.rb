class Roles::UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    role = Role.find(params[:role_id])
    user = User.find(params[:id])

    authorize role, :add_remove_role_user? 
    role.users << user if role.present? && user.present?
    head :ok
  end

  def destroy
    role = Role.find(params[:role_id])
    user = User.find(params[:id])

    authorize role, :add_remove_role_user? 
    user.roles.delete(role) if role.present? && user.present?
    head :no_content
  end

end
