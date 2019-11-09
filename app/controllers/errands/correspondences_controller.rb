class Errands::CorrespondencesController < CorrespondencesController
  before_action :set_correspondenable

  private

    def set_correspondenable
      @correspondenable = Errand.find(params[:errand_id])
    end

end