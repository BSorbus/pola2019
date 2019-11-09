class Events::OpinionsController < OpinionsController
  before_action :set_opinionable

  private

    def set_opinionable
      @opinionable = Event.find(params[:event_id])
    end

end