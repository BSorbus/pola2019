module InspectionProtocolsHelper

  def inspection_protocol_index_legend
    fa_icon("paperclip", text: t("pages.inspection_protocol.index.title"))
  end

  def inspection_protocol_edit_legend(data_obj)
    fa_icon("flag", text: t("pages.inspection_protocol.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_inspection_protocol_index_legend
    fa_icon("paperclip", text: t("pages.inspection_protocol.through_events_index.title"))
  end

end