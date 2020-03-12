class User < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :confirmable, 
         :recoverable,
         :registerable,
         :timeoutable, 
         :trackable, 
         :validatable,
         :lockable,
         :password_expirable,
         :secure_validatable, 
         :password_archivable, 
         :expirable

  # devise  :database_authenticatable, 
  #         :recoverable, 
  #         :registerable, 
  #         :timeoutable, 
  #         :trackable, 
  #         :validatable,
  #         :lockable,
  #           :password_expirable,
  #           :secure_validatable, 
  #           :password_archivable, 
  #           :expirable,
  #         :authentication_keys => [:email]

  # relations
  has_and_belongs_to_many :roles

  has_many :accessorizations, dependent: :nullify, index_errors: true

  has_many :attachments, as: :attachmenable, dependent: :destroy

  has_many :customers, dependent: :nullify
  has_many :projects, dependent: :nullify
  has_many :errands, dependent: :nullify
  has_many :events, dependent: :nullify

  has_many :business_trips, dependent: :nullify

  has_many :employee_business_trips, class_name: 'BusinessTrip', :foreign_key => 'employee_id'
  has_many :approved_business_trips, class_name: 'BusinessTrip', :foreign_key => 'approved_id'
  has_many :payment_approved_business_trips, class_name: 'BusinessTrip', :foreign_key => 'payment_on_account_approved_id'

  validate :password_complexity

  def password_complexity
    #if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\W])/)
    if password.present? and not password.match(/(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*(_|[\W]))/)
      errors.add :password, "Hasło musi zawierać małą literę, wielką literę and one symbol"
    end
  end

  # callbacks
  before_destroy :has_important_links, prepend: true

  # scope
  scope :has_notification_by_email, -> { where(notification_by_email: true) }

  def has_important_links
    analize_value = true
    if self.accessorizations.any? 
     errors.add(:base, 'Nie można usunąć konta "' + self.try(:fullname) + '" które jest powiązane z Zadaniami.')
     analize_value = false
    end
    throw :abort unless analize_value 
  end

  def flat_assigned_events 
    Accessorization.includes(:event, :role).where(user_id: self.id).order("events.end_date desc").map {|row| "#{row.event.try(:title_as_link)} - #{row.role.try(:name_as_link)}" }.join('<br>').html_safe
  end

  def flat_assigned_events_with_status 
    Accessorization.joins(event: [:event_status], role: []).where(user_id: self.id).order("events.end_date desc").map {|row| "#{row.event.try(:title_as_link)} - [#{row.event.event_status.name}] - #{row.role.try(:name_as_link)}" }.join('<br>').html_safe
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
    self.last_activity_at < Time.zone.now - 90.days
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

  def update_attachments_counter_cache(touch_date)
    files_count = attachments.where.not(attached_file: nil).count # Whatever condition you need here.
    files_size_sum = attachments.where.not(attached_file: nil).map { |a| a.attached_file.file.size }.sum

    self.update_columns(attachments_count: files_count, attachments_file_size_sum: files_size_sum, updated_at: touch_date)
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


end
