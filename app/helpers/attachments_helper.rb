module AttachmentsHelper

  def attachment_index_legend
    fa_icon("paperclip", text: t("pages.attachment.index.title"))
  end

  def attachment_edit_legend(data_obj)
    fa_icon("flag", text: t("pages.attachment.edit.title") + ": " + data_obj.fullname )
  end

  def through_events_attachment_index_legend
    fa_icon("paperclip", text: t("pages.attachment.through_events_index.title"))
  end

end