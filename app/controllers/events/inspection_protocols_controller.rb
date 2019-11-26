class Events::InspectionProtocolsController < InspectionProtocolsController
  before_action :set_inspectionable

  private

    def set_inspectionable
      @inspectionable = Event.find(params[:event_id])
    end

end