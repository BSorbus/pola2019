class Project < ApplicationRecord
  include ActionView::Helpers::TextHelper
  include  ActionView::Helpers::SanitizeHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :enrollment
  belongs_to :project_status
  belongs_to :customer

  has_many :point_files, dependent: :destroy
  has_many :proposal_files, dependent: :destroy
  has_one :last_active_point_file, -> { where(status: :active).order(load_date: :desc) },
    class_name: 'PointFile', foreign_key: :project_id
  has_one :last_active_proposal_file, -> { where(status: :active).order(load_date: :desc) },
    class_name: 'ProposalFile', foreign_key: :project_id

  has_many :events, dependent: :nullify, index_errors: true
  has_many :accesses_users, through: :events

  has_many :attachments, as: :attachmenable, dependent: :destroy

  has_many :events_attachments, through: :events, source: :attachments
  has_many :events_statements, through: :events, source: :statements
  has_many :events_correspondences, through: :events, source: :correspondences
  has_many :events_opinions, through: :events, source: :opinions
  has_many :events_protocols, through: :events, source: :protocols
  has_many :events_inspection_protocols, through: :events, source: :inspection_protocols
  has_many :events_measurements, through: :events, source: :measurements
  has_many :events_documentations, through: :events, source: :documentations
  has_many :events_infos, through: :events, source: :infos
  has_many :events_photos, through: :events, source: :photos

  has_many :works, as: :trackable

  # validates
  validates :number, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }
  validates :area_id, presence: true,
                    length: { in: 1..30 }
  validates :area_name, presence: true, unless: Proc.new { |a| a.enrollment_id == 1 }
  validates :area_name, length: { in: 1..40 }, allow_blank: true
  validates :customer_id, presence: true
  validates :enrollment_id, presence: true

  # callbacks
  before_destroy :has_important_links, prepend: true

  after_create_commit { self.log_work('create') }
  after_update_commit { self.log_work('update') }


  def is_closed
    project_status_id == ProjectStatus::PROJECT_STATUS_CLOSED ? true : false
  end

  def self.for_user_in_accessorizations(u)
    eager_load(events: [:accessorizations]).where(accessorizations: {user_id: [u]})
  end


  def has_important_links
    analize_value = true
    if self.events.any? 
     errors.add(:base, 'Nie można usunąć projektu "' + self.try(:fullname) + '" do którego są przypisane Zadania.')
     analize_value = false
    end
    throw :abort unless analize_value 
  end

  def log_work(action = '', action_user_id = nil)
    trackable_url = (action == 'destroy') ? nil : "#{url_helpers.project_path(self)}"
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: 'Project', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id, :enrollment_id, :customer_id, :project_status_id], 
        include: {project_status: {only: [:id, :name]}, 
                  enrollment: {only: [:id, :name]}, 
                  customer: {only: [:id, :name]}, 
                  user: {only: [:id, :name, :email]}}))
  end

  def send_notification_to_pool
    NotificationPoolJob.set(wait: 300.seconds).perform_later(self) unless self.is_closed
  end

  def fullname
    "#{self.number} [#{self.project_status.name}]"
  end

  def number_as_link
    "<a href=#{url_helpers.project_path(self)}>#{self.fullname}</a>".html_safe
  end

  def flat_assigned_events
    # 1. Without sort by user.name
    self.events.order(end_date: :desc).flat_map {|row| "#{row.try(:title_as_link)}" }.join('<br>').html_safe
  end

  def flat_assigned_events_with_status
    self.events.order(end_date: :desc).flat_map {|row| "#{row.try(:title_as_link)} - [#{row.event_status.name}]" }.join('<br>').html_safe
  end

  # Scope for select2: "project_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "2017 wymaga"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_project, ->(q) { where( create_sql_string("#{q}") ) }

  # Method create SQL query string for finder select2: "project_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "2017 wymaga"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((projects.number ilike '%2017%' OR projects.note ilike '%2017%') AND (projects.number ilike '%wymaga%' OR projects.note ilike '%wymaga%'))"
  #
  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  # Method for glue parameters in create_sql_string
  # * parameters   :
  #   * +one_query_word+ -> word for search. 
  #   Eg.: "2017"
  # * result   :
  #   * +sql_string+ -> SQL string query for one word 
  #   Eg.: "(projects.number ilike '%2017%' OR projects.note ilike '%2017%')"
  #
  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(projects.number projects.note).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end


end
