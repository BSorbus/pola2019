module CorrespondencesHelper

  ICON = "envelope"

  def correspondence_index_legend
    fa_icon(ICON, text: t("pages.correspondence.index.title"))
  end

  def correspondence_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.correspondence.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_correspondence_index_legend
    fa_icon(ICON, text: t("pages.correspondence.through_events_index.title"))
  end

end