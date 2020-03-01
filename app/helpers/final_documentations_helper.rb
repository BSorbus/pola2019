module FinalDocumentationsHelper

  ICON = "file-export"

  def final_documentation_index_legend
    fa_icon(ICON, text: t("pages.final_documentation.index.title"))
  end

  def final_documentation_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.final_documentation.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_final_documentation_index_legend
    fa_icon(ICON, text: t("pages.final_documentation.through_events_index.title"))
  end

end