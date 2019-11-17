class Events::ProtocolsController < ProtocolsController
  before_action :set_protocolable

  private

    def set_protocolable
      @protocolable = Event.find(params[:event_id])
    end

end