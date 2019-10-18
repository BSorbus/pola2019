# Preview all emails at http://localhost:3000/rails/mailers/status_mailer
class StatusMailerPreview < ActionMailer::Preview

  # def project_status_email(user, project)
  def project_status_email
    e = Event.last
    user = e.accessorizations.first.user
    message = "Test message"
    StatusMailer.project_status_email(user, e.project)
  end

  # def new_update_event_email(event)
  def new_update_event_email
    @event = Event.last
    StatusMailer.new_update_event_email(@event)
  end

  # def new_update_project_email(project)
  def new_update_project_email
    @project = Project.last
    StatusMailer.new_update_project_email(@project)
  end

end
