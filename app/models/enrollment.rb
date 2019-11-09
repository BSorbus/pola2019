class Enrollment < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user

  has_many :projects, dependent: :destroy

  has_many :attachments, as: :attachmenable, dependent: :destroy
  has_many :correspondences, as: :correspondenable, dependent: :destroy
  has_many :works, as: :trackable

  # validates
  validates :name, presence: true,
                    length: { in: 1..20 },
                    uniqueness: { case_sensitive: false }

  # callbacks
  before_destroy :has_important_links, prepend: true

  after_create_commit { self.log_work('create') }
  after_update_commit { self.log_work('update') }


  def has_important_links
    analize_value = true
    if self.projects.any? 
     errors.add(:base, 'Nie można usunąć naboru "' + self.try(:fullname) + '" do którego są przypisane Projekty.')
     analize_value = false
    end
    throw :abort unless analize_value 
  end

  def log_work(action = '', action_user_id = nil)
    trackable_url = (action == 'destroy') ? nil : "#{url_helpers.enrollment_path(self)}"
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: 'Enrollment', trackable_id: self.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id], include: {user: {only: [:id, :name, :email]}}))
  end

  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.enrollment_path(self)}>#{self.name}</a>".html_safe
  end

end
