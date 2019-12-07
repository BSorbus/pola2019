module ProposalFilesHelper

  ICON = "file-code"

  def proposal_file_dropdown_legend
    fa_icon(ICON, text: t("pages.proposal_file.dropdown.title"))
  end

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



  ICON_XML_DATA = "file"
  def proposal_file_xml_data_show_legend
    fa_icon(ICON_XML_DATA, text: t("pages.xml_data.show.title"))
  end
  def proposal_file_xml_data_info_legend(data_obj)
    proposal_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_XML_DATA, text: t("pages.xml_data.show.title") ) 
  end

  ICON_XML_MIEJSCE_REALIZACJI = "bookmark"
  def proposal_file_xml_miejsce_realizacji_show_legend
    fa_icon(ICON_XML_MIEJSCE_REALIZACJI, text: t("pages.xml_miejsce_realizacji_table.index.title"))
  end
  def proposal_file_xml_miejsce_realizacji_info_legend(data_obj)
    proposal_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_XML_MIEJSCE_REALIZACJI, text: t("pages.xml_miejsce_realizacji_table.index.title") ) 
  end

  ICON_XML_WYBRANA_TECHNOLOGIA = "microchip"
  def proposal_file_xml_wybrana_technologia_show_legend
    fa_icon(ICON_XML_WYBRANA_TECHNOLOGIA, text: t("pages.xml_wybrana_technologia_table.index.title"))
  end
  def proposal_file_xml_wybrana_technologia_info_legend(data_obj)
    proposal_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_XML_WYBRANA_TECHNOLOGIA, text: t("pages.xml_wybrana_technologia_table.index.title") ) 
  end

  ICON_XML_WSKAZNIK = "chart-bar"
  def proposal_file_xml_wskaznik_show_legend
    fa_icon(ICON_XML_WSKAZNIK, text: t("pages.xml_wskaznik_table.index.title"))
  end
  def proposal_file_xml_wskaznik_info_legend(data_obj)
    proposal_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_XML_WSKAZNIK, text: t("pages.xml_wskaznik_table.index.title") ) 
  end

  ICON_XML_ZADANIE = "tags"
  def proposal_file_xml_zadanie_show_legend
    fa_icon(ICON_XML_ZADANIE, text: t("pages.xml_zadanie_table.index.title"))
  end
  def proposal_file_xml_zadanie_info_legend(data_obj)
    proposal_file_info_legend(data_obj) + ' - ' + fa_icon(ICON_XML_ZADANIE, text: t("pages.xml_zadanie_table.index.title") ) 
  end

end