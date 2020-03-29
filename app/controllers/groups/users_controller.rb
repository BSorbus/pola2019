class Groups::UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    group = Group.find(params[:group_id])
    user = User.find(params[:id])

    authorize group, :add_remove_group_user? 
    group.users << user if group.present? && user.present?
    head :ok
  end

  def destroy
    group = Group.find(params[:group_id])
    user = User.find(params[:id])

    authorize group, :add_remove_group_user? 
    user.groups.delete(group) if group.present? && user.present?
    head :no_content
  end

end
