module InfosHelper

  ICON = "book-reader"

  def info_index_legend
    fa_icon(ICON, text: t("pages.info.index.title"))
  end

  def info_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.info.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_info_index_legend
    fa_icon(ICON, text: t("pages.info.through_events_index.title"))
  end

end