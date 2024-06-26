class UserPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    user_activities.include? 'user:index'
  end

  def show?
    (user_activities.include? 'user:show') || (user.id == model.id)
  end

  def new?
    create?
  end

  def create?
    user_activities.include? 'user:create'
  end

  def edit?
    update?
  end

  def update?
    (user_activities.include? 'user:update') || (user.id == model.id)
  end

  def destroy?
    user_activities.include? 'user:delete'
  end
 
 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end