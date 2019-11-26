class StatementPolicy < ApplicationPolicy
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
      case @model.statemenable.class.to_s
      when 'Customer'
        EventType.joins(events: {accessorizations: [:user], event_status: [], project: {customer: []}})
          .where(events: {accessorizations: {user_id: [@user]}, projects: {customer: [@model.statemenable]} })
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Project'
        EventType.joins(events: {accessorizations: [:user], event_status: [], project: []})
          .where(events: {accessorizations: {user_id: [@user]}, project: [@model.statemenable]})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Errand'
        EventType.joins(events: {accessorizations: [:user], event_status: [], errand: []})
          .where(events: {accessorizations: {user_id: [@user]}, errand: [@model.statemenable]})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Event'
        EventType.joins(events: {accessorizations: [:user], event_status: []})
          .where(events: {accessorizations: {user_id: [@user], event_id: [@model.statemenable]}})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      end
    end      
    # wybierz activites z events np.;
    # ["project:*", "opinion:*" ]
  end

  def event_user_activities
    if @model.class.to_s == 'Symbol'
      []
    else
      case @model.statemenable.class.to_s
      when 'Customer'
        Role.joins(accessorizations: {user:[], event: {event_status:[], project: [:customer]}})
          .where(accessorizations: {user: [@user], events: {projects: {customer: [@model.statemenable]}}})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Project'
        Role.joins(accessorizations: {user:[], event: [:event_status, :project]})
          .where(accessorizations: {user: [@user], events: {project: [@model.statemenable]}})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Errand'
        Role.joins(accessorizations: {user:[], event: [:event_status, :errand]})
          .where(accessorizations: {user: [@user], events: {errand: [@model.statemenable]}})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      when 'Event'
        Role.joins(accessorizations: {user:[], event: [:event_status]})
          .where(accessorizations: {user: [@user], event: [@model.statemenable]})
          .merge(EventStatus.status_can_change)
          .select(:activities).distinct.map(&:activities).flatten
      end
    end
    # wybierz activites for user accessorizations from events ex.;
    # ["*:index", "*:show", "*:create", "*:update", "*:delete", "*:project_index", "*:project_show", "*:project_create", "*:project_delete"]
  end


  # Attachments for showed customer 
  def customer_index?
    (user_activities.include? 'attachment:customer_index') || (event_activities(@model).include? 'attachment:customer_index')
  end

  def customer_show?
    (user_activities.include? 'attachment:customer_show') || (event_activities(@model).include? 'attachment:customer_show')
  end
 
  def customer_edit?
    customer_update?
  end

  def customer_update?
    customer_create?
  end

  def customer_create?
    (user_activities.include? 'attachment:customer_create') || (event_activities(@model).include? 'attachment:customer_create')
  end

  def customer_destroy?
    (user_activities.include? 'attachment:customer_delete') || (event_activities(@model).include? 'attachment:customer_delete')
  end


  # Attachments for showed project 
  def project_index?
    (user_activities.include? 'attachment:project_index') || (event_activities(@model).include? 'attachment:project_index')
  end

  def project_show?
    (user_activities.include? 'attachment:project_show') || (event_activities(@model).include? 'attachment:project_show')
  end
 
  def project_edit?
    project_update?
  end

  def project_update?
    project_create?
  end

  def project_create?
    (user_activities.include? 'attachment:project_create') || (event_activities(@model).include? 'attachment:project_create')
  end

  def project_destroy?
    (user_activities.include? 'attachment:project_delete') || (event_activities(@model).include? 'attachment:project_delete')
  end
 

  # Attachments for showed errand 
  def errand_index?
    (user_activities.include? 'attachment:errand_index') || (event_activities(@model).include? 'attachment:errand_index')
  end

  def errand_show?
    (user_activities.include? 'attachment:errand_show') || (event_activities(@model).include? 'attachment:errand_show')
  end
 
  def errand_edit?
    errand_update?
  end

  def errand_update?
    errand_create?
  end

  def errand_create?
    (user_activities.include? 'attachment:errand_create') || (event_activities(@model).include? 'attachment:errand_create')
  end

  def errand_destroy?
    (user_activities.include? 'attachment:errand_delete') || (event_activities(@model).include? 'attachment:errand_delete')
  end
 

  # Attachments for showed event 
  def event_index?
    (user_activities.include? 'attachment:event_index') || (event_activities(@model).include? 'attachment:event_index')
  end

  def event_show?
    (user_activities.include? 'attachment:event_show') || (event_activities(@model).include? 'attachment:event_show')
  end
 
  def event_edit?
    event_update?
  end

  def event_update?
    event_create?
  end

  def event_create?
    (user_activities.include? 'attachment:event_create') || (event_activities(@model).include? 'attachment:event_create')
  end

  def event_destroy?
    (user_activities.include? 'attachment:event_delete') || (event_activities(@model).include? 'attachment:event_delete')
  end


  # Attachments for showed user 
  def user_index?
    user_activities.include? 'attachment:user_index'
  end

  def user_show?
    user_activities.include? 'attachment:user_show'
  end
 
  def user_edit?
    user_update?
  end

  def user_update?
    user_create?
  end

  def user_create?
    user_activities.include? 'attachment:user_create'
  end

  def user_destroy?
    user_activities.include? 'attachment:user_delete'
  end
 

  # Attachments for showed enrollment 
  def enrollment_index?
    user_activities.include? 'attachment:enrollment_index'
  end

  def enrollment_show?
    user_activities.include? 'attachment:enrollment_show'
  end
 
  def enrollment_edit?
    enrollment_update?
  end

  def enrollment_update?
    enrollment_create?
  end

  def enrollment_create?
    user_activities.include? 'attachment:enrollment_create'
  end

  def enrollment_destroy?
    user_activities.include? 'attachment:enrollment_delete'
  end
 

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end