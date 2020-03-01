class OriginalDocumentation < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :original_documentionable, polymorphic: true

  # validates
  validates :attached_file, presence: true, file_size: { in: 1.byte..500.megabyte }

  # callbacks
  after_create_commit { self.log_work('upload_original_documentation') }
  after_update_commit { self.log_work('update') }
  after_commit :send_notification_to_model


  mount_uploader :attached_file, AbleUploader


  def log_work(action = '', action_user_id = nil)
    trackable_url = url_helpers(only_path: true, controller: self.original_documentionable.class.to_s.pluralize.downcase, action: 'show', id: self.original_documentionable.id)
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: "#{self.original_documentionable.class.to_s}", trackable_id: self.original_documentionable.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id], include: {user: {only: [:id, :name, :email]}}))
  end

  def destroy_and_log_work(current_user_id)
    destroyed_clone = self.clone
    destroyed_return = self.destroy
    if destroyed_return
      destroyed_clone.log_work('destroy_original_documentation', current_user_id)
    end
    return destroyed_return
  end

  def send_notification_to_model
    original_documentionable.send_notification_to_pool if (['Project']).include? self.original_documentionable.class.to_s
  end

  # validate :attached_file_size_validation

  # def attached_file_size_validation
  #   if attached_file.size > 1.megabytes
  #     errors.add(:base, "File should be less than 1MB")
  #     throw :abort 
  #   end
  # end

  def fullname
    "#{self.attached_file_identifier}"
  end

end
