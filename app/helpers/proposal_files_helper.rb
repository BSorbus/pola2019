module ProposalFilesHelper

  ICON = "calendar"

  def proposal_file_show_legend
    fa_icon(ICON, text: t("pages.proposal_file.show.title"))
  end

  def proposal_file_index_legend
    fa_icon(ICON, text: t("pages.proposal_file.index.title"))
  end

  def proposal_file_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.proposal_file.edit.title") + ": " + data_obj.fullname )
  end

  def proposal_file_new_legend(data_obj)
    fa_icon(ICON, text: t("pages.proposal_file.new.title"))
  end

  def proposal_file_info_legend(data_obj)
    proposal_file_show_legend + ": " + data_obj.fullname
  end

end
