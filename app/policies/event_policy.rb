class EventPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def permitted_attributes
    # if policy(:accessorization).create_update_delete?
    if AccessorizationPolicy.new(@user, :accessorization).create_update_delete?
      [:title, :all_day, :start_date, :end_date, :note, :project_id, :event_status_id, :event_type_id, :event_effect_id, :errand_id, :user_id, accessorizations_attributes: [:id, :event_id, :user_id, :role_id, :_destroy]]
    else
      [:title, :all_day, :start_date, :end_date, :note, :project_id, :event_status_id, :event_type_id, :event_effect_id, :errand_id, :user_id]
    end
  end

  def event_type_activities
    if @model.class.to_s == 'Symbol'
      EventType.joins(events: {accessorizations: [:user], event_status: []})
        .where(events: {accessorizations: {user_id: [@user]}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    else
      EventType.joins(events: {accessorizations: [:user], event_status: []})
        .where(events: {accessorizations: {user_id: [@user], event_id: [@model]}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end      
    # wybierz activites z events np.;
    # ["project:*", "opinion:*" ]
  end

  def event_user_activities
    if @model.class.to_s == 'Symbol'
      []
    else
      Role.joins(accessorizations: {user:[], event: [:event_status]})
        .where(accessorizations: {user: [@user], event: [@model]})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end
    # wybierz activites for user accessorizations from events ex.;
    # ["*:index", "*:show", "*:create", "*:update", "*:delete"]
  end

  def index?
    # user_activities.include? 'event:index'
    (user_activities.include? 'event:index') || (event_activities(@model).include? 'event:index')
  end

  def show?
    # user_activities.include? 'event:show'
    (user_activities.include? 'event:show') || (event_activities(@model).include? 'event:show')
  end
 
  def new?
    create?
  end

  def create?
    # user_activities.include? 'event:create'
    (user_activities.include? 'event:create') || (event_activities(@model).include? 'event:create')
  end

  def edit?
    update?
  end

  def update?
    # user_activities.include? 'event:update'
    (user_activities.include? 'event:update') || (event_activities(@model).include? 'event:update')
  end

  def destroy?
    # user_activities.include? 'event:delete'
    (user_activities.include? 'event:delete') || (event_activities(@model).include? 'event:delete')
  end
 
  def work?
    (user_activities.include? 'event:work') || (event_activities(@model).include? 'event:work')
  end
 
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end