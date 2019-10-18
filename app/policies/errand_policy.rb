class ErrandPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def event_type_activities
    if @model.class.to_s == 'Symbol'
      EventType.joins(events: {accessorizations: [:user], event_status: []})
        .where(events: {accessorizations: {user_id: [@user]}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    else
      EventType.joins(events: {accessorizations: [:user], event_status: [], errand: []})
        .where(events: {accessorizations: {user_id: [@user]}, errand: [@model]})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end      
    # wybierz activites z events np.;
    # ["errand:*", "opinion:*" ]
  end

  def event_user_activities
    if @model.class.to_s == 'Symbol'
      []
    else
      Role.joins(accessorizations: {user:[], event: [:event_status, :errand]})
        .where(accessorizations: {user: [@user], events: {errand: [@model]}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end
    # wybierz activites for user accessorizations from events ex.;
    # ["*:index", "*:show", "*:create", "*:update", "*:delete", "*:errand_index", "*:errand_show", "*:errand_create", "*:errand_delete"]
  end

  def index?
    (user_activities.include? 'errand:index') || (event_activities(@model).include? 'errand:index')
  end

  def show?
    (user_activities.include? 'errand:show') || (event_activities(@model).include? 'errand:show')
  end
 
  def new?
    create?
  end

  def create?
    (user_activities.include? 'errand:create') || (event_activities(@model).include? 'errand:create')
  end

  def edit?
    update?
  end

  def update?
    (user_activities.include? 'errand:update') || (event_activities(@model).include? 'errand:update')
  end

  def destroy?
    (user_activities.include? 'errand:delete') || (event_activities(@model).include? 'errand:delete')
  end

  def work?
    (user_activities.include? 'errand:work') || (event_activities(@model).include? 'errand:work')
  end
 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end