class Errand < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  include  ActionView::Helpers::SanitizeHelper

  # relations
  belongs_to :errand_status
  belongs_to :user

  has_many :events, dependent: :nullify, index_errors: true

  has_many :attachments, as: :attachmenable, dependent: :destroy
  has_many :correspondences, as: :correspondenable, dependent: :destroy
  has_many :works, as: :trackable

  # validates
  validates :number, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }
  validates :principal, presence: true,
                    length: { in: 1..100 }
  validates :order_date, presence: true


  # callbacks
  before_save :has_opened_events
  before_destroy :has_important_links, prepend: true

  after_create_commit { self.log_work('create') }
  after_update_commit { self.log_work('update') }


  def log_work(action = '', action_user_id = nil)
    trackable_url = (action == 'destroy') ? nil : "#{url_helpers.errand_path(self)}"
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: 'Errand', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:errand_status_id, :user_id], include: {errand_status: {only: [:id, :name]}, user: {only: [:id, :name, :email]}}))
  end

  def send_notification_to_pool
    NotificationPoolJob.set(wait: 300.seconds).perform_later(self) if self.errand_status_id != ErrandStatus::ERRAND_STATUS_CLOSED
  end

  def has_opened_events
    analize_value = true
    if self.errand_status_id === ErrandStatus::ERRAND_STATUS_CLOSED && self.events.where.not(event_status_id: EventStatus::EVENT_STATUS_CLOSED).any? 
      errors.add(:base, 'Nie można "zamknąć" zlecenia "' + self.try(:fullname) + '" do którego są przypisane Zadania o statusie innym niż "zamknięte".')
      analize_value = false
    end
    throw :abort unless analize_value 
  end

  def has_important_links
    analize_value = true
    if self.events.any? 
     errors.add(:base, 'Nie można usunąć zlecenia "' + self.try(:fullname) + '" do którego są przypisane Zadania.')
     analize_value = false
    end
    throw :abort unless analize_value 
  end

  def fullname
    "#{self.number} [#{self.order_date}, #{self.adoption_date}] [#{self.errand_status.name}]"
  end

  def number_as_link
    "<a href=#{url_helpers.errand_path(self)}>#{self.fullname}</a>".html_safe
  end

  scope :finder_errand, ->(q) { where( create_sql_string("#{q}") ) }

  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(errands.number errands.principal to_char(errands.order_date,'YYYY-mm-dd') to_char(errands.adoption_date,'YYYY-mm-dd')).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end

end
