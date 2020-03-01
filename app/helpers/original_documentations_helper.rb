module OriginalDocumentationsHelper

  ICON = "file-import"

  def original_documentation_index_legend
    fa_icon(ICON, text: t("pages.original_documentation.index.title"))
  end

  def original_documentation_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.original_documentation.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_original_documentation_index_legend
    fa_icon(ICON, text: t("pages.original_documentation.through_events_index.title"))
  end

end