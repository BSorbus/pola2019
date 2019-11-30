module DocumentationsHelper

  ICON = "book"

  def documentation_index_legend
    fa_icon(ICON, text: t("pages.documentation.index.title"))
  end

  def documentation_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.documentation.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_documentation_index_legend
    fa_icon(ICON, text: t("pages.documentation.through_events_index.title"))
  end

end