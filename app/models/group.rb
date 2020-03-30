class Group < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  has_and_belongs_to_many :users

  has_many :archivizations, dependent: :destroy
  has_many :accesses_archives, through: :archivizations, source: :archive


  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }


  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.group_path(self)}>#{self.name}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end


  # Scope for select2: "group_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_group, ->(q) { where( create_sql_string("#{q}") ) }

  # Method create SQL query string for finder select2: "group_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((groups.name ilike '%Jan%' OR groups.email ilike '%Jan%') AND (groups.name ilike '%ski@%' OR groups.email ilike '%ski@%'))"
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
  #   Eg.: "(groups.name ilike '%Jan%' OR groups.email ilike '%Jan%')"
  #
  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(groups.name).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end


end
