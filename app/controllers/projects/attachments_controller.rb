class Projects::AttachmentsController < AttachmentsController
  before_action :set_attachmenable

  private

    def set_attachmenable
      @attachmenable = Project.find(params[:project_id])
    end

end