class CustomerPolicy < ApplicationPolicy
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
      EventType.joins(events: {accessorizations: [:user], event_status: [], project: [:customer]})
        .where(events: {accessorizations: {user_id: [@user]}, projects: {customer_id: [@model]}})
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
      Role.joins(accessorizations: {user:[], event: {event_status: [], project: [:customer]}})
        .where(accessorizations: {user: [@user], events: {projects: {customer: [@model]}}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end
    # wybierz activites for user accessorizations from events ex.;
    # ["*:index", "*:show", "*:create", "*:update", "*:delete", "*:project_index", "*:project_show", "*:project_create", "*:project_delete"]
  end

  def index?
    (user_activities.include? 'customer:index') || (event_activities(@model).include? 'customer:index')
  end

  def show?
    (user_activities.include? 'customer:show') || (event_activities(@model).include? 'customer:show')
  end
 
  def new?
    create?
  end

  def create?
    (user_activities.include? 'customer:create') || (event_activities(@model).include? 'customer:create')
  end

  def edit?
    update?
  end

  def update?
    (user_activities.include? 'customer:update') || (event_activities(@model).include? 'customer:update')
  end

  def destroy?
    (user_activities.include? 'customer:delete') || (event_activities(@model).include? 'customer:delete')
  end

  def work?
    (user_activities.include? 'customer:work') || (event_activities(@model).include? 'customer:work')
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end