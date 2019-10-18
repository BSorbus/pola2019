class AddAttachmentsCountToAttachmenable < ActiveRecord::Migration[5.1]
  def up
    add_column :customers, :attachments_count, :integer, default: 0, null: false
    add_column :enrollments, :attachments_count, :integer, default: 0, null: false
    add_column :errands, :attachments_count, :integer, default: 0, null: false
    add_column :events, :attachments_count, :integer, default: 0, null: false
    add_column :projects, :attachments_count, :integer, default: 0, null: false
    add_column :users, :attachments_count, :integer, default: 0, null: false

    # Update the counter for existing records

		#Post.find_each { |post| Post.reset_counters(post.id, :comments) }

    Customer.find_each do |rec|
      Customer.reset_counters(rec.id, :attachments, touch: false)
    end
    Enrollment.find_each do |rec|
      Enrollment.reset_counters(rec.id, :attachments, touch: false)
    end
    Errand.find_each do |rec|
      Errand.reset_counters(rec.id, :attachments, touch: false)
    end
    Event.find_each do |rec|
      Event.reset_counters(rec.id, :attachments, touch: false)
    end
    Project.find_each do |rec|
      Project.reset_counters(rec.id, :attachments, touch: false)
    end
    User.find_each do |rec|
      User.reset_counters(rec.id, :attachments, touch: false)
    end
  end

  def down
    remove_column :customers, :attachments_count
    remove_column :enrollments, :attachments_count
    remove_column :errands, :attachments_count
    remove_column :events, :attachments_count
    remove_column :projects, :attachments_count
    remove_column :users, :attachments_count
  end
end
