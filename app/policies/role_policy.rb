class RolePolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    user_activities.include? 'role:index'
  end

  def index_only_not_special?
    user_activities.include? 'role:index_only_not_special'
  end

  def index_any?
    # (user_activities & ['role:index', 'role:index_only_not_special']).any?
    index? || index_only_not_special?
  end

  def show?
    if @model.is_special?
      user_activities.include? 'role:show'
    else
    # (user_activities & ['role:show', 'role:show_only_not_special']).any?
      (user_activities.include? 'role:show') || (user_activities.include? 'role:show_only_not_special') 
    end
  end

  def new?
    create?
  end

  def create?
    user_activities.include? 'role:create'
  end

  def edit?
    update?
  end

  def update?
    user_activities.include? 'role:update'
  end

  def destroy?
    user_activities.include? 'role:delete'
  end
 
  def add_remove_role_user?
    user_activities.include? 'role:add_remove_role_user'
  end
  
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end