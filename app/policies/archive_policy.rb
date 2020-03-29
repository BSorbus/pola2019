class ArchivePolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    user_activities.include? 'archive:index'
  end

  def show?
    user_activities.include? 'archive:show'
  end

  def new?
    create?
  end

  def create?
    user_activities.include? 'archive:create'
  end

  def edit?
    update?
  end

  def update?
    user_activities.include? 'archive:update'
  end

  def destroy?
    user_activities.include? 'archive:delete'
  end

  def work?
    user_activities.include? 'archive:work'
  end

 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end