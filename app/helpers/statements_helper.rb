module StatementsHelper

  ICON = "file-signature"

  def statement_index_legend
    fa_icon(ICON, text: t("pages.statement.index.title"))
  end

  def statement_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.statement.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_statement_index_legend
    fa_icon(ICON, text: t("pages.statement.through_events_index.title"))
  end

end