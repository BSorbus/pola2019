class NotificationPoolJob < ApplicationJob
  self.queue_as :notification

	attr_reader :notification_owner, :notification_owner_id

  after_enqueue do 
		owner = self.arguments[0].class.to_s
		owner_id = self.arguments[0].id

    delayed_job = Delayed::Job.find(self.provider_job_id)
    delayed_job.update(reference_id: owner_id, reference_type: owner)
  end


  def perform(rec)
		owner = self.arguments[0].class.to_s
		owner_id = self.arguments[0].id

		# remove previous same jobs 
		Delayed::Job.where(queue: "notification", reference_id: owner_id, reference_type: owner).delete_all

    case owner
    when 'Event' then 
    	StatusMailer.new_update_event_email(rec).deliver_now if rec.accesses_users.has_notification_by_email.any? || User.joins(:roles).where("'event:create' = ANY (roles.activities)").any?
    when 'Errand'  then
    	nil
    when 'Project'  then
      StatusMailer.new_update_project_email(rec).deliver_now if rec.accesses_users.has_notification_by_email.any? || User.joins(:roles).where("'project:create' = ANY (roles.activities)").any?
    else 
    	nil
    end

  end
end
