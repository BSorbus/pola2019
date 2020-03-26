class Attachment < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :attachmenable, polymorphic: true #, counter_cache: true    2020.03.11

  # validates
  validates :name, presence: true,
                   length: { in: 1..100 },
                   uniqueness: { case_sensitive: false, scope: [:attachmenable_id, :attachmenable_type, :parent_id], message: " - istnieje objekt o takiej nazwie (%{value})" }, allow_blank: true

  # validate unique name file 
  # validates :attached_file, presence: true,
  #                  length: { in: 1..100 },
  #                  uniqueness: { case_sensitive: false, scope: [:attachmenable_id, :attachmenable_type, :parent_id], message: " - istnieje plik o takiej nazwie" }, allow_blank: true

  # # ... or folder
  # validates :name_if_folder, presence: true,
  #                  length: { in: 1..100 },
  #                  uniqueness: { case_sensitive: false, scope: [:attachmenable_id, :attachmenable_type, :parent_id], message: " - istnieje katalog o takiej nazwie" }, allow_blank: true


  validates :attached_file, presence: true, file_size: { in: 1.byte..500.megabyte }, unless: -> { name_if_folder.present? }

  # callbacks
  before_validation do
    if name_if_folder.present?
      self.name = name_if_folder
    else 
      self.name = attached_file.present? ? attached_file.file.filename : nil
    end
  end

  after_save :update_custom_counter_cache
  after_destroy :update_custom_counter_cache


#  after_create_commit { self.log_work('upload_attachment') }
#  after_update_commit { self.log_work('update') }
  after_commit :send_notification_to_model

  # carrierwave uploader
  mount_uploader :attached_file, AbleUploader

  has_closure_tree dependent: :destroy, touch: true
  

  def self.only_for_parent(parent_id)
    where(parent_id: parent_id)
  end

  def is_file?
    !is_folder?
  end

  def is_folder?
    name_if_folder.present?     
  end

  def log_work(action = '', action_user_id = nil)
    url_show_path = "#{self.attachmenable.class.to_s.downcase}_path"
    trackable_url = eval( "Rails.application.routes.url_helpers.#{url_show_path}(only_path: true, controller: '#{self.attachmenable.class.to_s.pluralize.downcase}', action: 'show', id: #{self.attachmenable.id})")
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

  def move_to_photo_and_log_work(current_user_id)
    ApplicationRecord.transaction do
      photo = Photo.create(photoable_type: self.attachmenable_type, photoable_id: self.attachmenable_id, user_id: current_user_id)
      photo.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))
      photo.save!
      photo.attached_file.recreate_versions!(:thumb, :miniature)

      self.destroy_and_log_work(current_user_id)
    end
  end

  def move_to_parent_and_log_work(children, current_user_id)
    errors_array = []

    ApplicationRecord.transaction do
      children.each do |child_id|
        child = Attachment.find(child_id)
        update_ok = child.update(parent_id: self.id, user_id: current_user_id)
        if update_ok
          child.log_work('move_attachment', current_user_id)
        else
          errors_array << child.errors 
        end 
      end
    end

    return errors_array
  end


  def send_notification_to_model
#    attachmenable.send_notification_to_pool if (['Errand', 'Event', 'Project']).include? self.attachmenable.class.to_s     
  end

  # validate :attached_file_size_validation

  # def attached_file_size_validation
  #   if attached_file.size > 1.megabytes
  #     errors.add(:base, "File should be less than 1MB")
  #     throw :abort 
  #   end
  # end

  def fullname
    #{}"#{self.attached_file_identifier}"
    "#{self.name}"
  end

  private

    def only_file_path(path_with_file_name)
      length_path = path_with_file_name.length
      length_filename = path_with_file_name.reverse.index('/')
      path_with_file_name[0, (length_path-length_filename)]
    end

    def update_custom_counter_cache
      # disable counter_cache for definition: belongs_to :attachmenable, polymorphic: true #, counter_cache: true
      attachmenable.update_attachments_counter_cache
    end

end
