class Customers::AttachmentsController < AttachmentsController
  before_action :set_attachmenable

  private

    def set_attachmenable
      @attachmenable = Customer.find(params[:customer_id])
    end

end