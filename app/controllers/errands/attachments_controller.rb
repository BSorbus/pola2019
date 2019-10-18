class Errands::AttachmentsController < AttachmentsController
  before_action :set_attachmenable

  private

    def set_attachmenable
      @attachmenable = Errand.find(params[:errand_id])
    end

end