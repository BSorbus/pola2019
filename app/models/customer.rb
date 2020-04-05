class Customer < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
 
  has_many :projects, dependent: :destroy

  has_many :works, as: :trackable
  has_many :attachments, as: :attachmenable, dependent: :destroy

  # validates
  validates :name, presence: true,
                    length: { in: 1..150 },
                    uniqueness: { case_sensitive: false }
  validates :nip, length: { is: 10 }, numericality: true, 
                    uniqueness: { case_sensitive: false }, allow_blank: true
  validates :regon, length: { is: 9 }, numericality: true, 
                    uniqueness: { case_sensitive: false }, allow_blank: true
  validates :rpt, numericality: true, 
                    uniqueness: { case_sensitive: false }, allow_blank: true

  # callbacks
  before_destroy :has_important_links, prepend: true

  after_create_commit { self.log_work('create') }
  after_update_commit { self.log_work('update') }

  def self.for_user_in_accessorizations(u)
    eager_load(projects: {events: [:accessorizations]}).where(accessorizations: {user_id: [u]})
  end

  def has_important_links
    analize_value = true
    if self.projects.any? 
     errors.add(:base, 'Nie można usunąć konta "' + self.try(:fullname) + '" do którego są przypisane Projekty.')
     analize_value = false
    end
    throw :abort unless analize_value 
  end

  ##
  # Method for save data into log (works table)
  # * parameters   :
  #   * +action+ -> action name. 
  #   Ex.: "upload", "create"
  #   * +action_user_id+ -> if null then method get self.user_id. 
  #
  def log_work(action = '', action_user_id = nil)
    trackable_url = (action == 'destroy') ? nil : "#{url_helpers.customer_path(self)}"
    worker_id = action_user_id || self.user_id

    Work.create!(trackable_type: 'Customer', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id], include: {user: {only: [:id, :name, :email]}}))
  end

  def flat_assigned_projects
    self.projects.order("projects.number").flat_map {|row| "#{row.try(:number_as_link)}" }.join('<br>').html_safe
  end

  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.customer_path(self)}>#{self.name}</a>".html_safe
  end

  def name_as_link_truncate
    "<a href=#{url_helpers.customer_path(self)}>#{truncate(self.name, length: 100)}</a>".html_safe
  end


  ##
  # Scope for select2: "customer_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_customer, ->(q) { where( create_sql_string("#{q}") ) }

  ##
  # Method create SQL query string for finder select2: "customer_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((users.name ilike '%Jan%' OR users.email ilike '%Jan%') AND (customers.name ilike '%ski@%' OR customers.email ilike '%ski@%'))"
  #
  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  ##
  # Method for glue parameters in create_sql_string
  # * parameters   :
  #   * +one_query_word+ -> word for search. 
  #   Eg.: "Jan"
  # * result   :
  #   * +sql_string+ -> SQL string query for one word 
  #   Eg.: "(customers.name ilike '%Jan%' OR customers.email ilike '%Jan%')"
  #
  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(customers.name customers.address_city customers.nip customers.regon customers.rpt).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end

end
