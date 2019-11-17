module CorrespondencesHelper

  def correspondence_index_legend
    fa_icon("paperclip", text: t("pages.correspondence.index.title"))
  end

  def correspondence_edit_legend(data_obj)
    fa_icon("flag", text: t("pages.correspondence.edit.title") + ": " + data_obj.fullname )
  end

end