module OpinionsHelper

  def opinion_index_legend
    fa_icon("paperclip", text: t("pages.opinion.index.title"))
  end

  def opinion_edit_legend(data_obj)
    fa_icon("flag", text: t("pages.opinion.edit.title") + ": " + data_obj.fullname )
  end

end