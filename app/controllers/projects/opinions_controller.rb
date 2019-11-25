class Projects::OpinionsController < OpinionsController
  before_action :set_opinionable

  private

    def set_opinionable
      @opinionable = Project.find(params[:project_id])
    end

end