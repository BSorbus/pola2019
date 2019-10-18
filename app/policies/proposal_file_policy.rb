class ProposalFilePolicy < ApplicationPolicy
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
      EventType.joins(events: {accessorizations: [:user], event_status: [], project: []})
        .where(events: {accessorizations: {user_id: [@user]}, project: [@model.project]})
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
      Role.joins(accessorizations: {user:[], event: [:event_status, :project]})
        .where(accessorizations: {user: [@user], events: {project: [@model.project]}})
        .merge(EventStatus.status_can_change)
        .select(:activities).distinct.map(&:activities).flatten
    end
    # wybierz activites for user accessorizations from events ex.;
    # ["*:index", "*:show", "*:create", "*:update", "*:delete", "*:project_index", "*:project_show", "*:project_create", "*:project_delete"]
  end

  def index?
    (user_activities.include? 'proposal_file:index') || (event_activities(@model).include? 'proposal_file:index')
  end

  def download?
    (user_activities.include? 'proposal_file:download') || (event_activities(@model).include? 'proposal_file:download')
  end
 
  def show?
    (user_activities.include? 'proposal_file:show') || (event_activities(@model).include? 'proposal_file:show')
  end
 
  def new?
    create?
  end

  def create?
    (user_activities.include? 'proposal_file:create') || (event_activities(@model).include? 'proposal_file:create')
  end

  def edit?
    update?
  end

  def update?
    # user_activities.include? 'proposal_file:update'
    (user_activities.include? 'proposal_file:update') || (event_activities(@model).include? 'proposal_file:update')
  end

  def destroy?
    # user_activities.include? 'proposal_file:delete'
    (user_activities.include? 'proposal_file:delete') || (event_activities(@model).include? 'proposal_file:delete')
  end
 

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end