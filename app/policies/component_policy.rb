class ComponentPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def user_in_group_activities
    case @model.componentable.class.to_s
    when 'Archive'
      # same as in archive_policy
      at = ArchivizationType.joins(archivizations: {archive: [], group: { members: [:user]}})
        .where(archivizations: {archive: [@model.componentable], group: {members: {user_id: [@user]}}})
        .select(:activities).distinct.map(&:activities).flatten
      puts '########################### at ################################'
      puts at
      puts '########################### at ################################'
      at
    when 'XXX'
      []
    end
  end

  def owner_access
    if @model.class.to_s == 'Symbol'
      false
    else
      @model.user_id == @user.id || @model.componentable.user_id == @user.id
    end
  end


  def archive_index?
    true
  end

  def archive_show?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_show?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
  end

  def archive_show_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_show_uuid?'
    puts '--------------------------------------------------'
#    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
    archive_show?
  end

  def archive_download?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_download?'
    puts '--------------------------------------------------'
#    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
    archive_show?
  end

  def archive_download_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_download_uuid?'
    puts '--------------------------------------------------'
#    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
    archive_show?
  end

  def archive_zip_and_download?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_zip_and_download?'
    puts '--------------------------------------------------'
#    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
    archive_show?
  end

  def archive_move_to_parent?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_move_to_parent?'
    puts '--------------------------------------------------'
#    user_activities.include?('archivization:show') || (user_activities.include?('archivization:self_show') && owner_access) || user_in_group_activities.include?('archivization:show')
    archive_update?
  end




  def archive_create?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_create?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:create') || (user_activities.include?('archivization:self_create') && owner_access) || user_in_group_activities.include?('archivization:create')
  end

  def archive_edit?
    archive_update?
  end

  def archive_edit_uuid?
    archive_update_uuid?
  end

  def archive_update?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_update?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:update') || (user_activities.include?('archivization:self_update') && owner_access) || user_in_group_activities.include?('archivization:update')
  end

  def archive_update_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_update?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:update') || (user_activities.include?('archivization:self_update') && owner_access) || user_in_group_activities.include?('archivization:update')
  end

  def archive_destroy?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_destroy?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:delete') || (user_activities.include?('archivization:self_delete') && owner_access) || user_in_group_activities.include?('archivization:delete')
  end

  def archive_destroy_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_destroy_uuid?'
    puts '--------------------------------------------------'
    user_activities.include?('archivization:delete') || (user_activities.include?('archivization:self_delete') && owner_access) || user_in_group_activities.include?('archivization:delete')
  end

  def archive_work?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_work?'
    puts '--------------------------------------------------'
    true
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end