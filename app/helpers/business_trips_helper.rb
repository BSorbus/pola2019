module BusinessTripsHelper

  def business_trip_payment_approved_info(bt)
    if bt.payment_on_account_approved_id.present?
      bt_status = BusinessTripStatus.find(BusinessTripStatus::BUSINESS_TRIP_STATUS_PAYMENT_APPROVED).name
      "#{bt_status} - #{bt.payment_on_account_approved.fullname}, #{bt.payment_on_account_approved_date_time.strftime("%Y-%m-%d %H:%M")}"
    else
      ''
    end
  end

  def business_trip_info(bt)
    case bt.business_trip_status_id
    when BusinessTripStatus::BUSINESS_TRIP_STATUS_PROPOSAL
      ''
    when BusinessTripStatus::BUSINESS_TRIP_STATUS_APPROVED
      "#{bt.business_trip_status.name} - #{bt.approved.fullname}, #{bt.approved_date_time.strftime("%Y-%m-%d %H:%M")}"
    when BusinessTripStatus::BUSINESS_TRIP_STATUS_PROPOSAL_PAYMENT
      #"#{bt.business_trip_status.name} - #{bt.approved.fullname}, #{bt.approved_date_time.strftime("%Y-%m-%d %H:%M")} \n\r" +
      "#{bt.business_trip_status.name} - #{bt.payment_on_account_approved.fullname}, #{bt.payment_on_account_approved_date_time.strftime("%Y-%m-%d %H:%M")}"
    when BusinessTripStatus::BUSINESS_TRIP_STATUS_PAYMENT_APPROVED
      #"#{bt.business_trip_status.name} - #{bt.approved.fullname}, #{bt.approved_date_time.strftime("%Y-%m-%d %H:%M")}" + \r\n\ +
      "#{bt.business_trip_status.name} - #{bt.payment_on_account_approved.fullname}, #{bt.payment_on_account_approved_date_time.strftime("%Y-%m-%d %H:%M")}"
    end
  end
  
end
