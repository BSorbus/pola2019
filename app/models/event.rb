class Event < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :project
  belongs_to :event_status
  belongs_to :event_type
  belongs_to :event_effect, optional: true
  belongs_to :errand

  has_many :accessorizations, dependent: :destroy
  has_many :accesses_users, through: :accessorizations, source: :user

  has_many :attachments, as: :attachmenable, dependent: :destroy
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :works, as: :trackable

  # validates
  validates :title, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { scope: [:project_id], message: " - takie zadanie jest już zdefiniowane w tym projekcie" }
  validates :project_id, presence: true
  validates :errand_id, presence: true

  validate :end_after_start
  validates :start_date, presence: true
  validates :end_date, presence: true

  accepts_nested_attributes_for :accessorizations, reject_if: :all_blank, allow_destroy: true

  # callbacks
  before_create { self.title = "#{title} - #{self.project.number}" }
  
  after_create_commit :create_additionals
  after_update_commit { self.log_work('update') }


  def is_closed
    event_status_id == EventStatus::EVENT_STATUS_CLOSED ? true : false 
  end

  def self.for_user_in_accessorizations(u)
    eager_load(:accessorizations).where(accessorizations: {user_id: [u]})
  end

  # @events = Event.where(start_date: params[:start]..params[:end]).or(Event.where(end_date: params[:start]..params[:end]))
  def self.for_start_dates(for_start, for_end)
    where(start_date: for_start..for_end)
  end

  def self.for_end_dates(for_start, for_end)
    where(end_date: for_start..for_end)
  end

  def create_additionals
    self.log_work('create')
    self.build_default_attachment_folders
  end

  def log_work(action = '', action_user_id = nil)
    trackable_url = (action == 'destroy') ? nil : "#{url_helpers.event_path(self)}"
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: 'Event', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id, :project_id, :event_status_id, :event_type_id, :errand_id], 
        include: {project: {only: [:id, :number]}, 
                  event_status: {only: [:id, :name]}, 
                  event_type: {only: [:id, :name]}, 
                  errand: {only: [:id, :name]}, 
                  accessorizations: {only: [:id, :event_id], include: {user: {only: [:id, :name, :email]}, role: {only: [:id, :name]}} }, 
                  user: {only: [:id, :name, :email]}}
      )
    )
  end

  def send_notification_to_pool
    NotificationPoolJob.set(wait: 300.seconds).perform_later(self) unless self.is_closed
  end

  def fullname
    "#{self.title}"
  end

  def flat_assigned_users
    # 1. Without sort by user.name
    # self.accessorizations.order(:id).flat_map {|row| row.link_assigned_user_as }.join('<br>').html_safe
 
    # 2. With sort by user.name, but OUTER LEFT join.
    #Accessorization.includes(:user, :role).where(event_id: self.id).order("users.name").map {|row| "#{row.user.present? ? row.user.name_as_link : ''} - #{row.role.present? ? row.role.name_as_link : ''}" }.join('<br>').html_safe

    # 3. change {row.user.present? ? row.user.name_as_link : ''}  -> {row.user.try(:name_as_link)}
    Accessorization.includes(:user, :role).where(event_id: self.id).order("users.name").map {|row| "#{row.user.try(:name_as_link)} - #{row.role.try(:name_as_link)}" }.join('<br>').html_safe
  end

  def title_as_link
    "<a href=#{url_helpers.event_path(self)}>#{self.fullname}</a>".html_safe
  end

  def color_value
    if self.event_status_id == EventStatus::EVENT_STATUS_CLOSED
      'gray'
    else 
      case (self.end_date.to_date - Time.zone.now.to_date).to_i
      when -99999999..3
        'red'
      when 4..7
        'fuchsia'
      when 8..14
        'orange'
      when 15..30
        'green'
      else 
        ''      
      end
    end
  end


  def access_attachments?
    self.event_type.blank? ? false : self.event_type.access_to_attachments?
  end

  def access_statements?
    self.event_type.blank? ? false : self.event_type.access_to_statements?
  end

  def access_authorizations?
    self.event_type.blank? ? false : self.event_type.access_to_authorizations?
  end

  def access_correspondences?
    self.event_type.blank? ? false : self.event_type.access_to_correspondences?
  end

  def access_ratings?
    self.event_type.blank? ? false : self.event_type.access_to_ratings?
  end

  def access_opinions?
    self.event_type.blank? ? false : self.event_type.access_to_opinions?
  end

  def access_protocols?
    self.event_type.blank? ? false : self.event_type.access_to_protocols?
  end

  def access_inspection_protocols?
    self.event_type.blank? ? false : self.event_type.access_to_inspection_protocols?
  end

  def access_measurements?
    self.event_type.blank? ? false : self.event_type.access_to_measurements?
  end

  def access_documentations?
    self.event_type.blank? ? false : self.event_type.access_to_documentations?
  end

  def access_infos?
    self.event_type.blank? ? false : self.event_type.access_to_infos?
  end

  def access_photos?
    self.event_type.blank? ? false : self.event_type.access_to_photos?
  end

  def access_controlls?
    self.event_type.blank? ? false : self.event_type.access_to_controlls?
  end

  def update_attachments_counter_cache
    files_count = attachments.where.not(attached_file: nil).count # Whatever condition you need here.
    files_size_sum = attachments.where.not(attached_file: nil).map { |a| a.attached_file.file.size }.sum

    self.update_columns(attachments_count: files_count, attachments_file_size_sum: files_size_sum)
  end

  def build_default_attachment_folders(create_timestamp=nil)
    build_folder("Oświadczenia", create_timestamp)  if access_statements?
    build_folder("Korespondencja", create_timestamp) if access_correspondences?
    build_folder("Ocena", create_timestamp) if access_ratings? 
    build_folder("Opinia zmian", create_timestamp) if access_opinions? 
    build_folder("Upoważnienia", create_timestamp) if access_authorizations? 
    build_folder("Protokoły oględzin", create_timestamp) if access_inspection_protocols? 
    build_folder("Pomiary", create_timestamp).tap do |rec|
      rec.add_child build_folder("Reflektometryczne", create_timestamp)
      rec.add_child build_folder("Jakościowe", create_timestamp)
    end if access_measurements? 
    build_folder("Informacja pokontrolna", create_timestamp) if access_infos? 
  end

  def build_folder(folder_name, create_timestamp=nil)
    attachments.find_or_create_by!(name_if_folder: "#{folder_name}") do |att|
      att.user = self.user
      att.created_at = create_timestamp.present? ? create_timestamp : self.created_at
      att.updated_at = create_timestamp.present? ? create_timestamp : self.updated_at
      att.save!
    end
  end

  private

    def end_after_start
      return if end_date.blank? || start_date.blank?
     
      if end_date < start_date
        errors.add(:end_date, 'nie może być wcześniejsza "Początek"') 
        throw :abort 
      end 
    end

end
