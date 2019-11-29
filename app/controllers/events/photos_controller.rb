class Events::PhotosController < PhotosController
  before_action :set_photoable

  private

    def set_photoable
      @photoable = Event.find(params[:event_id])
    end

end