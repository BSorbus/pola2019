class Events::MeasurementsController < MeasurementsController
  before_action :set_measurementable

  private

    def set_measurementable
      @measurementable = Event.find(params[:event_id])
    end

end