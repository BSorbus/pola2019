class ArchivePolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def permitted_attributes
    permitted_array = [:name, :note]
    # if ArchivePolicy.new(@user, @model).add_remove_archive_group?
    #   permitted_array = [:name, :note, accessorizations_attributes: [:id, :event_id, :user_id, :role_id, :_destroy]]
    # else
    #   permitted_array = [:title, :all_day, :start_date, :end_date, :note, :project_id, :event_status_id, :event_type_id, :errand_id, :user_id]
    # end
    if @model.class.to_s == 'Symbol'
      permitted_array << [archivizations_attributes: [:id, :archives_id, :group_id, :archivization_type_id, :_destroy]] if user_activities.include?('archive:add_remove_archive_group') || user_activities.include?('archive:self_add_remove_archive_group')
    else
      permitted_array << [archivizations_attributes: [:id, :archives_id, :group_id, :archivization_type_id, :_destroy]] if ArchivePolicy.new(@user, @model).add_remove_archive_group?
    end
    permitted_array
  end


  def user_in_group_activities
    # ArchivizationType.joins(archivizations: {archive: [], group: members: {[:users]}})
    #   .where(archivizations: {archive: [@model], group: {members: {users: {id: [@user]}}} })
    #   .select(:activities).distinct.map(&:activities).flatten

    # ArchivizationType.joins(archivizations: {archive: [], group: { members: [:user]}})
    #   .where(archivizations: {archive: [@model], group: {members: {user: [@user]}}})
    #   .select(:activities).distinct.map(&:activities).flatten

    ArchivizationType.joins(archivizations: {archive: [], group: { members: [:user]}})
      .where(archivizations: {archive: [@model], group: {members: {user_id: [@user]}}})
      .select(:activities).distinct.map(&:activities).flatten
  end

  def owner_access
    if @model.class.to_s == 'Symbol'
      false
    else
      @model.user_id == @user.id
    end
  end

  def index?
#    user_activities.include? 'archive:index'
true
  end

  def show?
    user_activities.include?('archive:show') || (user_activities.include?('archive:self_show') && owner_access) || user_in_group_activities.include?('archive:show')
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
    user_activities.include?('archive:update') || (user_activities.include?('archive:self_update') && owner_access) || user_in_group_activities.include?('archive:update')
  end

  def destroy?
    user_activities.include?('archive:delete') || (user_activities.include?('archive:self_delete') && owner_access) || user_in_group_activities.include?('archive:delete')
  end

  def work?
    user_activities.include?('archive:work') || user_in_group_activities.include?('archive:work')
  end

  def add_remove_archive_group?
    user_activities.include?('archive:add_remove_archive_group') || (user_activities.include?('archive:self_add_remove_archive_group') && owner_access) || user_in_group_activities.include?('archive:add_remove_archive_group')
  end
  
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end