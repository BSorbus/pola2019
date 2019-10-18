class Enrollments::AttachmentsController < AttachmentsController
  before_action :set_attachmenable

  private

    def set_attachmenable
      @attachmenable = Enrollment.find(params[:enrollment_id])
    end

end