class Events::InfosController < InfosController
  before_action :set_infoable

  private

    def set_infoable
      @infoable = Event.find(params[:event_id])
    end

end