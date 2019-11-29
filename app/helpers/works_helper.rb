module WorksHelper

  ICON = "history"

  def work_index_legend
    fa_icon(ICON, text: t("pages.work.index.title"))
  end

end