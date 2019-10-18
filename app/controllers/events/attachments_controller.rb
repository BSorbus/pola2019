class Events::AttachmentsController < AttachmentsController
  before_action :set_attachmenable

  private

    def set_attachmenable
      @attachmenable = Event.find(params[:event_id])
    end

end