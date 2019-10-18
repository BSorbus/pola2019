class EnrollmentPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    user_activities.include? 'enrollment:index'
  end

  def show?
    user_activities.include? 'enrollment:show'
  end

  def new?
    create?
  end

  def create?
    user_activities.include? 'enrollment:create'
  end

  def edit?
    update?
  end

  def update?
    user_activities.include? 'enrollment:update'
  end

  def destroy?
    user_activities.include? 'enrollment:delete'
  end

  def work?
    user_activities.include? 'enrollment:work'
  end

 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end