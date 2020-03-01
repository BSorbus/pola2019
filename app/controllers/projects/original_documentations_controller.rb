class Projects::OriginalDocumentationsController < OriginalDocumentationsController
  before_action :set_original_documentionable

  private

    def set_original_documentionable
      @original_documentionable = Project.find(params[:project_id])
    end

end