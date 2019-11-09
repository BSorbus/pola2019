class Enrollments::CorrespondencesController < CorrespondencesController
  before_action :set_correspondenable

  private

    def set_correspondenable
      @correspondenable = Enrollment.find(params[:enrollment_id])
    end

end