class BusinessTrip < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :business_trip_status
  belongs_to :user
  belongs_to :employee, :class_name => 'User'
  belongs_to :approved, :class_name => 'User', required: false
  belongs_to :payment_on_account_approved, :class_name => 'User', required: false

  has_many :transports, inverse_of: :business_trip, dependent: :destroy
  has_many :roads, dependent: :destroy

  # validates
  validates :number, presence: true,
                    length: { in: 1..20 },
                    uniqueness: { case_sensitive: false }
  validates :employee_id, presence: true
  validates :destination, presence: true,
                    length: { in: 1..150 }
  validates :purpose, presence: true,
                    length: { minimum: 3 }

  validate :end_after_start
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :must_have_transport

  accepts_nested_attributes_for :transports, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :roads, reject_if: :all_blank, allow_destroy: true


  def fullname
    "#{number}"
  end

  def number_as_link
    "<a href=#{url_helpers.business_trip_path(self)}>#{self.number}</a>".html_safe
  end

  def log_work(action = '', action_user_id = nil)
    # trackable_url = (action == 'destroy') ? nil : "#{url_helpers.event_path(self)}"
    # worker_id = action_user_id || self.user_id
    # Work.create!(trackable_type: 'Event', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
    #   parameters: self.to_json(except: [:user_id, :project_id, :event_status_id, :event_type_id, :errand_id], 
    #     include: {project: {only: [:id, :number]}, 
    #               event_status: {only: [:id, :name]}, 
    #               event_type: {only: [:id, :name]}, 
    #               errand: {only: [:id, :name]}, 
    #               accessorizations: {only: [:id, :event_id], include: {user: {only: [:id, :name, :email]}, role: {only: [:id, :name]}} }, 
    #               user: {only: [:id, :name, :email]}}
    #   )
    # )
  end

  private

    def end_after_start
      return if end_date.blank? || start_date.blank?
     
      if end_date < start_date
        errors.add(:end_date, 'nie może być wcześniejsza od "Na czas od"') 
        throw :abort 
      end 
    end

    def must_have_transport
      errors.add(:transports, '- musi zostać określony przynajmniej jeden') if bad_transports?
    end

    def bad_transports?
      # puts '-----------------------------------------------'
      # puts transports.collect.as_json
      # transports.each {|row| puts row.marked_for_destruction? }
      # puts '-----------------------------------------------'


      #transports.each.map(&:marked_for_destruction?).uniq.include? false


      transports.empty? or transports.all? {|row| row.marked_for_destruction? }

# {"id"=>6, "business_trip_id"=>1, "transport_type_id"=>1, "created_at"=>Sun, 10 Mar 2019 13:31:12 CET +01:00, "updated_at"=>Sun, 10 Mar 2019 13:31:12 CET +01:00}
# {"id"=>8, "business_trip_id"=>1, "transport_type_id"=>3, "created_at"=>Sun, 10 Mar 2019 13:51:42 CET +01:00, "updated_at"=>Sun, 10 Mar 2019 13:51:42 CET +01:00}
# {"id"=>nil, "business_trip_id"=>1, "transport_type_id"=>2, "created_at"=>nil, "updated_at"=>nil}
# false
# true
# false
    end

end
