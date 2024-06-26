class User < ApplicationRecord

  USER_DEFAULT_FIRST_NAME = "nowy"
  USER_DEFAULT_LAST_NAME  = "użytkownik"
  USER_DEFAULT_USER_NAME  = "nowy użytkownik"

  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  devise :saml_authenticatable, :trackable

  # relations
  has_and_belongs_to_many :roles

  has_many :members #, dependent: :destroy
  has_many :groups, through: :members


  has_many :accessorizations, dependent: :nullify, index_errors: true

  has_many :attachments, as: :attachmenable, dependent: :destroy

  has_many :customers, dependent: :nullify
  has_many :projects, dependent: :nullify
  has_many :errands, dependent: :nullify
  has_many :events, dependent: :nullify
  has_many :archives, dependent: :nullify

  has_many :accesses_events, through: :accessorizations, source: :event


  # validates
  validates :user_name, presence: true,
                    length: { in: 1..100 }

  validates :email, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }


  # callbacks
  before_validation :set_initial_data_corrected #, on: :create
  before_destroy :has_important_links, prepend: true
  after_commit :set_default_data, on: :create

  # scope
  scope :has_notification_by_email, -> { where(notification_by_email: true, deleted_at: nil) }

  def flat_assigned_events 
    Accessorization.includes(:event, :role).where(user_id: self.id).order("events.end_date desc").map {|row| "#{row.event.try(:title_as_link)} - #{row.role.try(:name_as_link)}" }.join('<br>').html_safe
  end

  def flat_assigned_events_with_status 
    Accessorization.joins(event: [:event_status], role: []).where(user_id: self.id).order("events.end_date desc").map {|row| "#{row.event.try(:title_as_link)} - [#{row.event.event_status.name}] - #{row.role.try(:name_as_link)}" }.join('<br>').html_safe
  end


  def name
    "#{first_name} #{last_name}"
  end

  def fullname_and_id
    "#{first_name} #{last_name} (#{id})"
  end


  def name_was
    "#{first_name_was} #{last_name_was}"
  end

  def fullname
    name.blank? ? "#{email}" : "#{email} (#{name})"
  end

  def fullname_was
    name_was.blank? ? "#{email_was}" : "#{email_was} (#{name_was})"
  end

  def last_name_to_display
    (last_name == USER_DEFAULT_LAST_NAME || last_name.blank?) ? "" : last_name    
  end

  def first_name_to_display
    (first_name == USER_DEFAULT_FIRST_NAME || first_name.blank?) ? "" : first_name    
  end


  def fullname
    "#{name} (#{email})"
  end

  def name_as_link
    "<a href=#{url_helpers.user_path(self)}>#{self.name}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end

  def last_activity_at_expired?
    if self.last_activity_at.present?
      self.last_activity_at < Time.zone.now - 90.days
    else
      true
    end
  end

  # Scope for select2: "user_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_user, ->(q) { where( create_sql_string("#{q}") ) }

  # Method create SQL query string for finder select2: "user_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((users.name ilike '%Jan%' OR users.email ilike '%Jan%') AND (users.name ilike '%ski@%' OR users.email ilike '%ski@%'))"
  #
  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  # Method for glue parameters in create_sql_string
  # * parameters   :
  #   * +one_query_word+ -> word for search. 
  #   Eg.: "Jan"
  # * result   :
  #   * +sql_string+ -> SQL string query for one word 
  #   Eg.: "(users.name ilike '%Jan%' OR users.email ilike '%Jan%')"
  #
  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(users.name users.email).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end

  # instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end  
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  
  
  # provide a custom message for a deleted account   
  def inactive_message   
    !deleted_at ? super : :deleted_account  
  end  

  def build_default_attachment_folders
  end


  # Integration with ActiveJob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    super
    Work.create( trackable_id: self.id, trackable_type: 'User', trackable_url: "#{Rails.application.routes.url_helpers.user_path(self)}", action: 'account_confirmation', user_id: self.id, 
      parameters: {id: self.id, name: self.name, email: self.email}.to_json )
  end

  # this gets called every time a request fails due to lacking authentication
  Warden::Manager.before_failure do |env, opts|
    # parse params
    # Rack::Request.new(env).params

    # authentication failed:
    # opts == {:scope=>:user, :recall=>"devise/sessions#new", :action=>"unauthenticated", :attempted_path=>"/users/sign_in"}

    # redirect as a user is required
    # opts == {:scope=>:user, :action=>"unauthenticated", :attempted_path=>"/"}
    # 'trigger sign in failed' if opts.has_key?(:recall)

      my_hash = opts
      my_hash[:REMOTE_ADDR] = env["REMOTE_ADDR"]
      my_hash[:REQUEST_URI] = env["REQUEST_URI"]
      #my_hash["rack.session"] = env["rack.session"] # za dużo danych

      # usuwa "password" z hasha
      my_hash["rack.request.form_hash"] = Hash[env["rack.request.form_hash"].map {|k,v| [k,(v.respond_to?(:except)?v.except("password"):v)] }] if env["rack.request.form_hash"].present?
      # get a flash notice! 
      my_hash["flash"] = deep_find(:flash, env["rack.session"], found=nil) 

      Work.create( action: 'unauthenticated', user_id: nil, parameters: my_hash.to_json ) if opts.has_key?(:recall)
  end


  #Warden::Manager.after_failed_fetch do |user, auth, opts|
  #  #your custom code
  #    puts "##########################################################"
  #    puts "# Warden::Manager.after_failed_fetch "
  #    puts user
  #    puts auth
  #    puts opts
  #    puts "##########################################################"
  #  #'trigger user request'
  #end


  def self.deep_find(key, object=self, found=nil)
    if object.respond_to?(:key?) && object.key?(key)
      return object[key]
    elsif object.is_a? Enumerable
      object.find { |*a| found = deep_find(key, a.last) }
      return found
    end
  end

  private
    def set_initial_data_corrected
      self.email.downcase if self.email.present?
      
      self.first_name = USER_DEFAULT_FIRST_NAME if self.first_name.blank?
      self.last_name  = USER_DEFAULT_LAST_NAME  if self.last_name.blank?
      self.user_name  = USER_DEFAULT_USER_NAME  if self.user_name.blank?

      user_name  = "#{first_name} #{last_name}"
    end 

    def has_important_links
      analize_value = true
      if self.accessorizations.any? 
       errors.add(:base, 'Nie można usunąć konta "' + self.try(:fullname) + '" które jest powiązane z Zadaniami.')
       analize_value = false
      end
      throw :abort unless analize_value 
    end

    def set_default_data
      # if author_id.blank?
      #   self.update_columns(author_id: id) 
      # end
    end

end
