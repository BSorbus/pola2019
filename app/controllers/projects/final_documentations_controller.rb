class Projects::FinalDocumentationsController < FinalDocumentationsController
  before_action :set_final_documentionable

  private

    def set_final_documentionable
      @final_documentionable = Project.find(params[:project_id])
    end

end