class Component < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :user
  belongs_to :componentable, polymorphic: true

  # validates
  validates :name, presence: true,
                   length: { in: 1..100 },
                   uniqueness: { case_sensitive: false, scope: [:componentable_id, :componentable_type, :parent_id], message: " - istnieje objekt o takiej nazwie (%{value})" }, allow_blank: true

  validates :component_file, presence: true, 
                    file_content_type: { exclude: [ 'application/x-msdos-program',
                                                    'application/cmd',
                                                    'application/x-ms-dos-executable',
                                                    'application/x-javascript', 
                                                    'application/x-msi',
                                                    'application/x-php',
                                                    'application/x-python',
                                                    'application/x-vbs' ] },
                    file_size: { in: 1.byte..500.megabyte }, unless: -> { name_if_folder.present? }

  # callbacks
	after_initialize :set_initial_data

  before_validation do
    if name_if_folder.present?
      self.name = name_if_folder
    else 
      self.name = component_file.present? ? component_file.file.filename : nil
    end
  end

  # carrierwave uploader
  mount_uploader :component_file, ComponentUploader

  has_closure_tree dependent: :destroy, touch: true
  

  def self.only_for_parent(parent_id)
    where(parent_id: parent_id)
  end

  def is_file?
#    !is_folder?
    component_file.present?
  end

  def is_folder?
#    name_if_folder.present?     
    !is_file?
  end

  def log_work(action = '', action_user_id = nil)
    url_show_path = "#{self.componentable.class.to_s.downcase}_path"
    trackable_url = eval( "Rails.application.routes.url_helpers.#{url_show_path}(only_path: true, controller: '#{self.componentable.class.to_s.pluralize.downcase}', action: 'show', id: #{self.componentable.id})")
    worker_id = action_user_id || self.user_id

    Work.create!(trackable_type: "#{self.componentable.class.to_s}", trackable_id: self.componentable.id, trackable_url: trackable_url, action: "#{action}", user_id: worker_id, 
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

  def self.move_to_parent_and_log_work(parent, children, current_user_id)
    errors_array = []
    parent = nil if ( parent.blank? || parent == 'null' || parent == '' || parent == 0 )

    ApplicationRecord.transaction do
      children.each do |child_id|
        child = Component.find(child_id)
        if child.parent_id != parent 
          update_ok = child.update(parent_id: parent, user_id: current_user_id)
          if update_ok
            child.log_work('move_attachment', current_user_id)
          else
            errors_array << child.errors 
          end
        end
      end
    end

    return errors_array
  end

  def fullname
    #{}"#{self.attached_file_identifier}"
    "#{self.name}"
  end

  def my_send_file
    "send_file #{component_file.path}, 
      filename: #{component_file.file.filename}, 
      type: #{file_content_type},
      dispostion: 'inline', 
      status: 200, 
      stream: true, 
      x_sendfile: true"
  end

  private
  
    def set_initial_data
      self.component_uuid = SecureRandom.uuid unless self.component_uuid.present?
    end	

end
