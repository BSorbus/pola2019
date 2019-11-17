module StatementsHelper

  def statement_index_legend
    fa_icon("paperclip", text: t("pages.statement.index.title"))
  end

  def statement_edit_legend(data_obj)
    fa_icon("flag", text: t("pages.statement.edit.title") + ": " + data_obj.fullname )
  end

end