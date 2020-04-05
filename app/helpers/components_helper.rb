module ComponentsHelper

  ICON = "paperclip"

  def component_index_legend
    fa_icon(ICON, text: t("pages.component.index.title"))
  end

  def component_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.component.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_component_index_legend
    fa_icon(ICON, text: t("pages.component.through_events_index.title"))
  end

end