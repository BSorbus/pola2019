module ProtocolsHelper

  ICON = "file-contract"

  def protocol_index_legend
    fa_icon(ICON, text: t("pages.protocol.index.title"))
  end

  def protocol_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.protocol.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_protocol_index_legend
    fa_icon(ICON, text: t("pages.protocol.through_events_index.title"))
  end

end