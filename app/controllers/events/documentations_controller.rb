class Events::DocumentationsController < DocumentationsController
  before_action :set_documentationable

  private

    def set_documentationable
      @documentationable = Event.find(params[:event_id])
    end

end