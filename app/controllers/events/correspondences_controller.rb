class Events::CorrespondencesController < CorrespondencesController
  before_action :set_correspondenable

  private

    def set_correspondenable
      @correspondenable = Event.find(params[:event_id])
    end

end