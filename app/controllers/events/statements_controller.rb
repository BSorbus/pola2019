class Events::StatementsController < StatementsController
  before_action :set_statemenable

  private

    def set_statemenable
      @statemenable = Event.find(params[:event_id])
    end

end