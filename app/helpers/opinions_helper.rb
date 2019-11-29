module OpinionsHelper

  ICON = "gavel"

  def opinion_index_legend
    fa_icon(ICON, text: t("pages.opinion.index.title"))
  end

  def opinion_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.opinion.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_opinion_index_legend
    fa_icon(ICON, text: t("pages.opinion.through_events_index.title"))
  end

end