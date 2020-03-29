module GroupsHelper

  ICON = "user-friends"

  def group_show_legend
    fa_icon(ICON, text: t("pages.group.show.title"))
  end

  def group_index_legend
    fa_icon(ICON, text: t("pages.group.index.title"))
  end

  def group_edit_legend(data_obj)
    fa_icon(ICON, text: t("pages.group.edit.title") + ": " + data_obj.fullname )
  end

  def group_new_legend(data_obj)
    fa_icon(ICON, text: t("pages.group.new.title"))
  end

  def group_info_legend(data_obj)
    group_show_legend + ": " + data_obj.fullname
  end

end
