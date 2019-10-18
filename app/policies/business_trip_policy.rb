class BusinessTripPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index_self?
    user_activities.include? 'business_trip:index_self'
  end

  def index?
    user_activities.include? 'business_trip:index'
  end

  def show_self?
    user_activities.include? 'business_trip:show_self'
  end

  def show?
    user_activities.include? 'business_trip:show'
  end

  def new_self?
    create_self?
  end

  def new?
    create?
  end

  def create_self?
    user_activities.include? 'business_trip:create_self'
  end

  def create?
    user_activities.include? 'business_trip:create'
  end

  def edit_self?
    update_self?
  end

  def edit?
    update?
  end

  def update_self?
    user_activities.include? 'business_trip:update_self'
  end

  def update?
    user_activities.include? 'business_trip:update'
  end

  def destroy_self?
    user_activities.include? 'business_trip:delete_self'
  end

  def destroy?
    user_activities.include? 'business_trip:delete'
  end

  def work_self?
    user_activities.include? 'business_trip:work_self'
  end

  def work?
    user_activities.include? 'business_trip:work'
  end

  def approved?
    user_activities.include? 'business_trip:approved'
  end

  def payment_approved?
    user_activities.include? 'business_trip:payment_approved'
  end

 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end