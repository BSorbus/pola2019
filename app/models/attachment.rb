class Attachment < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :attachmenable, polymorphic: true, counter_cache: true

  # validates
  validates :attached_file, presence: true, file_size: { in: 1.byte..500.megabyte }

  # callbacks
  after_create_commit { self.log_work('upload_attachment') }
  after_update_commit { self.log_work('update') }
  after_commit :send_notification_to_model

  mount_uploader :attached_file, AbleUploader

  def log_work(action = '', action_user_id = nil)
    trackable_url = url_helpers(only_path: true, controller: self.attachmenable.class.to_s.pluralize.downcase, action: 'show', id: self.attachmenable.id)
    worker_id = action_user_id || self.user_id
    Work.create!(trackable_type: "#{self.attachmenable.class.to_s}", trackable_id: self.attachmenable.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
      parameters: self.to_json(except: [:user_id], include: {user: {only: [:id, :name, :email]}}))
  end

  def destroy_and_log_work(current_user_id)
    destroyed_clone = self.clone
    destroyed_return = self.destroy
    if destroyed_return
      destroyed_clone.log_work('destroy_attachment', current_user_id)
    end
    return destroyed_return
  end


  def move_to_correspondence_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      correspondence = Correspondence.create(correspondenable_type: self.attachmenable_type, correspondenable_id: self.attachmenable_id, user_id: current_user_id)
      correspondence.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      correspondence.save!
      correspondence.attached_file.recreate_versions!(:thumb)

      self.destroy_and_log_work(current_user_id)
    end
  end

  def move_to_opinion_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      opinion = Opinion.create(opinionable_type: self.attachmenable_type, opinionable_id: self.attachmenable_id, user_id: current_user_id)
      opinion.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      opinion.save!
      opinion.attached_file.recreate_versions!(:thumb)

      self.destroy_and_log_work(current_user_id)
    end
  end

  def move_to_protocol_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      protocol = Protocol.create(protocolable_type: self.attachmenable_type, protocolable_id: self.attachmenable_id, user_id: current_user_id)
      protocol.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      protocol.save!
      protocol.attached_file.recreate_versions!(:thumb)

      self.destroy_and_log_work(current_user_id)
    end
  end

  def move_to_statement_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      statement = Statement.create(statemenable_type: self.attachmenable_type, statemenable_id: self.attachmenable_id, user_id: current_user_id)
      statement.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      statement.save!
      statement.attached_file.recreate_versions!(:thumb)

      self.destroy_and_log_work(current_user_id)
    end
  end

  def move_to_photo_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      photo = Photo.create(photoable_type: self.attachmenable_type, photoable_id: self.attachmenable_id, user_id: current_user_id)
      photo.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      photo.save!
      #photo.attached_file.recreate_versions!(:thumb, :small)
      photo.attached_file.recreate_versions!(:thumb)

      self.destroy_and_log_work(current_user_id)
    end
  end


  def send_notification_to_model
    attachmenable.send_notification_to_pool if (['Errand', 'Event', 'Project']).include? self.attachmenable.class.to_s     
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

  private

    def only_file_path(path_with_file_name)
      length_path = path_with_file_name.length
      length_filename = path_with_file_name.reverse.index('/')
      path_with_file_name[0, (length_path-length_filename)]
    end

end
