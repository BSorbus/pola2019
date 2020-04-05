class ComponentPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
  	puts '--------------------------------------------------'
  	puts 'ComponentPolicy: initialize(user, model)'
  	puts '--------------------------------------------------'
    @user = user
    @model = model
  end

  def index?
    true
  end

  def show?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: show?'
    puts '--------------------------------------------------'
    true
  end

  def archive_show?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_show?'
    puts '--------------------------------------------------'
    true
  end

  def archive_show_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_show_uuid?'
    puts '--------------------------------------------------'
    true
  end

  def archive_download?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_download?'
    puts '--------------------------------------------------'
    true
  end

  def archive_download_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_download_uuid?'
    puts '--------------------------------------------------'
    true
  end

  def create?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: create?'
    puts '--------------------------------------------------'
    true
  end

  def archive_create?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_create?'
    puts '--------------------------------------------------'
    true
  end

  def edit?
    update?
  end

  def archive_edit?
    archive_update?
  end

  def update?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: update?'
    puts '--------------------------------------------------'
    true
  end

  def archive_update?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_update?'
    puts '--------------------------------------------------'
    true
  end

  def destroy?
    true
  end

  def archive_destroy?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_destroy?'
    puts '--------------------------------------------------'
    true
  end

  def archive_destroy_uuid?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: archive_destroy_uuid?'
    puts '--------------------------------------------------'
    true
  end

  def work?
    puts '--------------------------------------------------'
    puts 'ComponentPolicy: work?'
    puts '--------------------------------------------------'
    true
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