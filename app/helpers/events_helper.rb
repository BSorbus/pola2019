module EventsHelper

  def event_show_legend
    fa_icon("calendar", text: t("pages.event.show.title"))
  end

  def event_index_legend
    fa_icon("calendar", text: t("pages.event.index.title"))
  end

  def event_edit_legend(data_obj)
    fa_icon("calendar", text: t("pages.event.edit.title") + ": " + data_obj.fullname )
  end

  def event_new_legend(data_obj)
    fa_icon("calendar", text: t("pages.event.new.title"))
  end

  def event_info_legend(data_obj)
    event_show_legend + ": " + data_obj.fullname
  end

end
