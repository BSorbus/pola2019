class ProposalFile < ApplicationRecord
  enum status: [:inactive, :active]

  mount_uploader :load_file, ProposalFileUploader

  # relations
  belongs_to :project

  has_many :xml_partner_tables, dependent: :destroy, index_errors: true
  has_many :xml_miejsce_realizacji_tables, through: :xml_partner_tables

  has_many :xml_projekt_tables, dependent: :destroy, index_errors: true
  has_many :xml_wskaznik_tables, through: :xml_projekt_tables
  has_many :xml_wybrana_technologia_tables, through: :xml_projekt_tables
  has_many :xml_zadanie_tables, through: :xml_projekt_tables
  has_many :xml_kamien_milowy_tables, through: :xml_zadanie_tables

  # validates
  validates :load_file, presence: true,
                        file_size: { less_than: 50.megabytes }
  validates :status, presence: true,
                    uniqueness: { scope: [:project_id] }, if: :status_active?

  # callbacks
  before_save :loading_file_is_valid?, on: :create

  accepts_nested_attributes_for :xml_partner_tables, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :xml_projekt_tables, reject_if: :all_blank, allow_destroy: true

  def loading_file_is_valid?
    unless check_xml_file
      errors.add(:load_file, '"' + load_file.file.original_filename + '" nie jest prawidłowym plikiem XML projektu POPC (nabór 2)".')
      throw :abort 
    end
  end

  def status_active?
    self.active?
  end

  def fullname
    "#{self.load_file_identifier}"
  end

  def check_xml_file
    doc = Nokogiri::XML(File.open("#{self.load_file.file.path}", "r")) do |config|
      config.strict.nonet
    end

    required_1 = '2' #10
    required_2 = 'POPC'
    line_1 = ''
    line_2 = ''

    doc.xpath("//*[local-name()='Dokument']").each do |dokument|
      dokument.xpath("//*[local-name()='TrescDokumentu']").each do |tresc_dokumentu|
        tresc_dokumentu.xpath("./*[local-name()='Wniosek']").each do |wniosek|
          #puts wniosek.xpath("./*[local-name()='NumerWniosku']").text
          wniosek.xpath("./*[local-name()='Nabor']").each do |nabor|
            line_1 = nabor.xpath("./*[local-name()='Id']").text
            line_2 = nabor.xpath("./*[local-name()='Opis']").text.present? ? nabor.xpath("./*[local-name()='Opis']").text.first(4) : ''
          end #/nabor
        end #/wniosek
      end #/tresc_dokumentu
    end #/dokument

    #line_1 == required_1 && line_2 == required_2
    line_2 == required_2
  end

  def load_data_from_xml_file
    pf_attributes = {}

    doc = Nokogiri::XML(File.open("#{self.load_file.file.path}")) do |config|
      config.strict.nonet
    end

    doc.xpath("//*[local-name()='Dokument']").each do |dokument|
      dokument.xpath("//*[local-name()='TrescDokumentu']").each do |tresc_dokumentu|

        tresc_dokumentu.xpath("./*[local-name()='Wniosek']").each do |wniosek|
          wniosek.xpath("./*[local-name()='Nabor']").each do |nabor|
            # puts 'wniosek->nabór->id:' +nabor.xpath("./*[local-name()='Id']").text
            # puts 'wniosek->nabór->opis:' +nabor.xpath("./*[local-name()='Opis']").text
            pf_attributes.merge!(nabor_id: nabor.xpath("./*[local-name()='Id']").text)  
            pf_attributes.merge!(nabor_opis: nabor.xpath("./*[local-name()='Opis']").text)  
          end #/nabor
          wniosek.xpath("./*[local-name()='Rodzaj']").each do |rodzaj|
            # puts 'wniosek->rodzaj->id:' +rodzaj.xpath("./*[local-name()='Id']").text
            # puts 'wniosek->rodzaj->opis:' +rodzaj.xpath("./*[local-name()='Opis']").text
            pf_attributes.merge!(rodzaj_id: rodzaj.xpath("./*[local-name()='Id']").text)  
            pf_attributes.merge!(rodzaj_opis: rodzaj.xpath("./*[local-name()='Opis']").text)  
          end #rodzaj
        end #/wniosek

        pf_attributes.merge!(xml_projekt_tables_attributes: {})
        tresc_dokumentu.xpath("./*[local-name()='Projekt']").each_with_index do |projekt, projekt_index|
          pf_attributes[:xml_projekt_tables_attributes].merge!("#{projekt_index}"=>{})  
          projekt.xpath("./*[local-name()='DaneOgolne']").each do |dane_ogolne|
            # puts 'projekt->dane_ogolne->tytul:' +dane_ogolne.xpath("./*[local-name()='Tytul']").text
            pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(do_tytul: dane_ogolne.xpath("./*[local-name()='Tytul']").text)

            dane_ogolne.xpath("./*[local-name()='OkresRealizacji']").each do |okres_realizacji|
              # puts 'projekt->dane_ogolne->okres_realizacji->DataOd:' +okres_realizacji.xpath("./*[local-name()='DataOd']").text
              # puts 'projekt->dane_ogolne->okres_realizacji->DataDo:' +okres_realizacji.xpath("./*[local-name()='DataDo']").text
              pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(
                do_okres_realizacji_data_od: okres_realizacji.xpath("./*[local-name()='DataOd']").text,
                do_okres_realizacji_data_do: okres_realizacji.xpath("./*[local-name()='DataDo']").text
              )
            end #/okres_realizacji
            dane_ogolne.xpath("./*[local-name()='OkresKwalifikowalnosciWydatkow']").each do |okres_kwalifikowalnosci_wydatkow|
              # puts 'projekt->dane_ogolne->okres_kwalifikowalnosci_wydatkow->DataOd:' +okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataOd']").text
              # puts 'projekt->dane_ogolne->okres_kwalifikowalnosci_wydatkow->DataOd:' +okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataDo']").text
              pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(
                do_okres_kwalifikowalnosci_wydatkow_data_od: okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataOd']").text,
                do_okres_kwalifikowalnosci_wydatkow_data_do: okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataDo']").text
              )
            end #/okres_kwalifikowalnosci_wydatkow
            dane_ogolne.xpath("./*[local-name()='TechnologieRealizacjiProjektu']").each do |technologie_realizacji_projektu|
              pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(xml_wybrana_technologia_tables_attributes: {})
              technologie_realizacji_projektu.xpath("./*[local-name()='WybraneTechnologie']").each_with_index do |wybrane_technologie, wybrane_technologie_index|
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes].merge!("#{wybrane_technologie_index}"=>{}) 
                wybrane_technologie.xpath("./*[local-name()='Element']").each_with_index do |element, element_index|
                  # puts '----------------------------------------------------------------------------------------------------------------'
                  # puts pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes]["#{wybrane_technologie_index}"]
                  # puts pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes]
                  # puts 'projekt->dane_ogolne->technologie_realizacji_projektu->wybrane_technologie->element-id:' +element.xpath("./*[local-name()='Id']").text
                  # puts 'projekt->dane_ogolne->technologie_realizacji_projektu->wybrane_technologie->element-opis:' +element.xpath("./*[local-name()='Opis']").text
                  # puts '----------------------------------------------------------------------------------------------------------------'
                  # pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes]["#{wybrane_technologie_index}"].merge!(
                  pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes].merge!(
                    "#{element_index}"=> {
                      element_id: element.xpath("./*[local-name()='Id']").text,
                      element_opis: element.xpath("./*[local-name()='Opis']").text
                    }
                  )  
                end #/element
              end #/wybrane_technologie
              if technologie_realizacji_projektu.xpath("./*[local-name()='InnaTechnologia']").text.present?
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wybrana_technologia_tables_attributes].merge!("999999999"=>{
                  element_id: 'INNA',
                  element_opis: technologie_realizacji_projektu.xpath("./*[local-name()='InnaTechnologia']").text
                })
              end 
            end #/technologie_realizacji_projektu
          end #/ogolne_dane

          projekt.xpath("./*[local-name()='WskaznikiMierzalneOgolne']").each do |wskazniki_mierzalne_ogolne|
            wskazniki_mierzalne_ogolne.xpath("./*[local-name()='WskaznikiMierzalne']").each do |wskazniki_mierzalne|
              pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(xml_wskaznik_tables_attributes: {})
              wskazniki_mierzalne.xpath("./*[local-name()='Wskaznik']").each_with_index do |wskaznik, wskaznik_index|
                # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->numer:' +wskaznik.xpath("./*[local-name()='Numer']").text
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wskaznik_tables_attributes].merge!("#{wskaznik_index}"=>{ 
                  numer: wskaznik.xpath("./*[local-name()='Numer']").text
                })  
                wskaznik.xpath("./*[local-name()='Nazwa']").each do |nazwa|
                  # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->id:' +nazwa.xpath("./*[local-name()='Id']").text
                  # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->kod:' +nazwa.xpath("./*[local-name()='Kod']").text
                  # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->opis:' +nazwa.xpath("./*[local-name()='Opis']").text
                  pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wskaznik_tables_attributes]["#{wskaznik_index}"].merge!(
                    nazwa_id: nazwa.xpath("./*[local-name()='Id']").text,
                    nazwa_kod: nazwa.xpath("./*[local-name()='Kod']").text,
                    nazwa_opis: nazwa.xpath("./*[local-name()='Opis']").text
                  )  
                end
                # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->typ:' +wskaznik.xpath("./*[local-name()='Typ']").text
                # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->JednostkaMiary->opis:' +wskaznik.xpath("./*[local-name()='JednostkaMiary']").xpath("./*[local-name()='Opis']").text
                # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->wartosc_docelowa:' +wskaznik.xpath("./*[local-name()='WartoscDocelowa']").text
                # puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->czy_wlasny:' +wskaznik.xpath("./*[local-name()='CzyWlasny']").text
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_wskaznik_tables_attributes]["#{wskaznik_index}"].merge!(
                  typ: wskaznik.xpath("./*[local-name()='Typ']").text,
                  jednostka_miary_opis: wskaznik.xpath("./*[local-name()='JednostkaMiary']").xpath("./*[local-name()='Opis']").text,
                  wartosc_bazowa: wskaznik.xpath("./*[local-name()='WartoscBazowa']").text,
                  wartosc_docelowa: wskaznik.xpath("./*[local-name()='WartoscDocelowa']").text
                )  
              end #/wskaznik
            end #/wskazniki_mierzalne
          end #/wskazniki_mierzalne_ogolne

          projekt.xpath("./*[local-name()='ZakresRzeczowy']").each do |zakres_rzeczowy|
            zakres_rzeczowy.xpath("./*[local-name()='Zadania']").each do |zadania|
              pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(xml_zadanie_tables_attributes: {})
              zadania.xpath("./*[local-name()='Zadanie']").each_with_index do |zadanie, zadanie_index|
                # puts 'projekt->zakres_rzeczowy->zadania->zadanie->zadanie:' +zadanie.xpath("./*[local-name()='Zadanie']").text
                # puts 'projekt->zakres_rzeczowy->zadania->zadanie->nr_zadania:' +zadanie.xpath("./*[local-name()='NumerZadania']").text
                # puts 'projekt->zakres_rzeczowy->zadania->zadanie->nr_zadania:' +zadanie.xpath("./*[local-name()='Nazwa']").text
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_zadanie_tables_attributes].merge!("#{zadanie_index}"=>{ 
                  zadanie: zadanie.xpath("./*[local-name()='Zadanie']").text,
                  numer_zadania: zadanie.xpath("./*[local-name()='NumerZadania']").text,
                  nazwa: zadanie.xpath("./*[local-name()='Nazwa']").text
                })  

                zadanie.xpath("./*[local-name()='InformacjeDoKamieniMilowych']").each do |informacje_do_kamieni_milowych|
                  # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->data_rozpoczecia:' +informacje_do_kamieni_milowych.xpath("./*[local-name()='DataRozpoczecia']").text
                  # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->planowana_data_zakonczenia:' +informacje_do_kamieni_milowych.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text
                  pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_zadanie_tables_attributes]["#{zadanie_index}"].merge!( 
                    idkm_data_rozpoczecia: informacje_do_kamieni_milowych.xpath("./*[local-name()='DataRozpoczecia']").text,
                    idkm_planowana_data_zakonczenia: informacje_do_kamieni_milowych.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text
                  )  
      
                  informacje_do_kamieni_milowych.xpath("./*[local-name()='KamienieMilowe']").each do |kamienie_milowe|
                    pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_zadanie_tables_attributes]["#{zadanie_index}"].merge!(xml_kamien_milowy_tables_attributes: {}) 
                    kamienie_milowe.xpath("./*[local-name()='KamienMilowy']").each_with_index do |kamien_milowy, kamien_milowy_index|
                      # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->nazwa:' +kamien_milowy.xpath("./*[local-name()='Nazwa']").text
                      # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->czy_oznacza_zakonczenie_zadania:' +kamien_milowy.xpath("./*[local-name()='CzyOznaczaZakonczenieZadania']").text
                      # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->planowana_data_zakonczenia:' +kamien_milowy.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text
                      # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->data_punktu_krytycznego:' +kamien_milowy.xpath("./*[local-name()='DataPunktuKrytycznego']").text
                      # puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->data_punktu_ostatecznego:' +kamien_milowy.xpath("./*[local-name()='DataPunktuOstatecznego']").text
                      pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"][:xml_zadanie_tables_attributes]["#{zadanie_index}"][:xml_kamien_milowy_tables_attributes].merge!("#{kamien_milowy_index}"=>{ 
                        nazwa: kamien_milowy.xpath("./*[local-name()='Nazwa']").text,
                        czy_oznacza_zakonczenie: kamien_milowy.xpath("./*[local-name()='CzyOznaczaZakonczenieZadania']").text,
                        planowana_data_zakonczenia: kamien_milowy.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text,
                        data_punktu_krytycznego: kamien_milowy.xpath("./*[local-name()='DataPunktuKrytycznego']").text,
                        data_punktu_ostatecznego: kamien_milowy.xpath("./*[local-name()='DataPunktuOstatecznego']").text
                      })
                    end #kamien_milowy
                  end #kamienie_milowe

                end #/informacje_do_kamieni_milowych
              end #/zadanie
            end #zadania
          end #/zakres_rzeczowy

          projekt.xpath("./*[local-name()='MontazFinansowyProjektu']").each do |montaz_finansowy_projektu|
            montaz_finansowy_projektu.xpath("./*[local-name()='MontazFinansowyOgolem']").each do |montaz_finansowy_ogolem|
              montaz_finansowy_ogolem.xpath("./*[local-name()='MontazFinansowy']").each do |montaz_finansowy|
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wydatki_ogolem:' +montaz_finansowy.xpath("./*[local-name()='WydatkiOgolem']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wydatki_kwalifikowane:' +montaz_finansowy.xpath("./*[local-name()='WydatkiKwalifikowane']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->dofinansowanie:' +montaz_finansowy.xpath("./*[local-name()='Dofinansowanie']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->procent_dofinansowania:' +montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowania']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wklad_ue:' +montaz_finansowy.xpath("./*[local-name()='WkladUE']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->procent_dofinansowania_ue:' +montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowaniaUE']").text  
                # puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wklad_wlasny:' +montaz_finansowy.xpath("./*[local-name()='WkladWlasny']").text  
                pf_attributes[:xml_projekt_tables_attributes]["#{projekt_index}"].merge!(
                  mfp_mfo_mf_wydatki_ogolem: montaz_finansowy.xpath("./*[local-name()='WydatkiOgolem']").text,
                  mfp_mfo_mf_wydatki_kwalifikowane: montaz_finansowy.xpath("./*[local-name()='WydatkiKwalifikowane']").text,
                  mfp_mfo_mf_dofinansowanie: montaz_finansowy.xpath("./*[local-name()='Dofinansowanie']").text,
                  mfp_mfo_mf_procent_dofinansowania: montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowania']").text,
                  mfp_mfo_mf_wklad_ue: montaz_finansowy.xpath("./*[local-name()='WkladUE']").text,
                  mfp_mfo_mf_procent_dofinansowanie_ue: montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowaniaUE']").text,
                  mfp_mfo_mf_wklad_wlasny: montaz_finansowy.xpath("./*[local-name()='WkladWlasny']").text
                )

              end #/montaz_finansowy
            end #/montaz_finansowy_ogolem        
          end #/montaz_finansowy_projektu
        end #/projekt    

        pf_attributes.merge!(xml_partner_tables_attributes: {})
        tresc_dokumentu.xpath("./*[local-name()='Partnerzy']").each do |partnerzy|  
          partnerzy.xpath("./*[local-name()='Partner']").each_with_index do |partner, partner_index|
            # puts 'partnerzy->partner->numer_wpisu_uke:' +partner.xpath("./*[local-name()='NumerWpisuUKE']").text
            pf_attributes[:xml_partner_tables_attributes].merge!("#{partner_index}"=>{numer_wpisu_uke: partner.xpath("./*[local-name()='NumerWpisuUKE']").text}) 
            partner.xpath("./*[local-name()='DanePodmiotu']").each do |dane_podmiotu|
              # puts 'partnerzy->partner->dane_podmiotu->nazwa:' +dane_podmiotu.xpath("./*[local-name()='Nazwa']").text
              # puts 'partnerzy->partner->dane_podmiotu->nip:' +dane_podmiotu.xpath("./*[local-name()='NIP']").text
              # puts 'partnerzy->partner->dane_podmiotu->regon:' +dane_podmiotu.xpath("./*[local-name()='REGON']").text
              pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!( 
                dp_nazwa: dane_podmiotu.xpath("./*[local-name()='Nazwa']").text,
                dp_nip: dane_podmiotu.xpath("./*[local-name()='NIP']").text,  
                dp_regon: dane_podmiotu.xpath("./*[local-name()='REGON']").text
              )  

              dane_podmiotu.xpath("./*[local-name()='AdresSiedziby']").each do |adres_siedziby|
                adres_siedziby.xpath("./*[local-name()='Miejscowosc']").each do |miejscowosc|
                  # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->miejscowosc->id:' +miejscowosc.xpath("./*[local-name()='Id']").text
                  # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->miejscowosc->opis:' +miejscowosc.xpath("./*[local-name()='Opis']").text
                  pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!( 
                    dp_as_miejscowosc_id: miejscowosc.xpath("./*[local-name()='Id']").text,
                    dp_as_miejscowosc_opis: miejscowosc.xpath("./*[local-name()='Opis']").text
                  )  
                end #/miejscowosc
                adres_siedziby.xpath("./*[local-name()='Ulica']").each do |ulica|
                  # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->ulica->id:' +ulica.xpath("./*[local-name()='Id']").text
                  # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->ulica->opis:' +ulica.xpath("./*[local-name()='Opis']").text
                  pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!( 
                    dp_as_ulica_id: ulica.xpath("./*[local-name()='Id']").text,
                    dp_as_ulica_opis: ulica.xpath("./*[local-name()='Opis']").text
                  )  
                end #/ulica
                # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->nr:' +adres_siedziby.xpath("./*[local-name()='Nr']").text
                # puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->kod_pocztowy:' +adres_siedziby.xpath("./*[local-name()='KodPocztowy']").text
                pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!(
                  dp_as_kod_pocztowy: adres_siedziby.xpath("./*[local-name()='KodPocztowy']").text,
                  dp_as_nr: adres_siedziby.xpath("./*[local-name()='Nr']").text,
                  dp_as_lokal: adres_siedziby.xpath("./*[local-name()='Lokal']").text,
                  dp_as_telefon: adres_siedziby.xpath("./*[local-name()='Telefon']").text,
                  dp_as_faks: adres_siedziby.xpath("./*[local-name()='Faks']").text,
                  dp_as_email: adres_siedziby.xpath("./*[local-name()='Email']").text,
                  dp_as_epuap: adres_siedziby.xpath("./*[local-name()='Epuap']").text
                  )
              end #/adres_siedziny
            end #/dane_podmiotu

            partner.xpath("./*[local-name()='MiejscaRealizacjiProjektu']").each do |miejsca_realizacji_projektu|
              miejsca_realizacji_projektu.xpath("./*[local-name()='ObszarRealizacji']").each do |obszar_realizacji|
                # puts 'partnerzy->partner->miejsca_realizacji_projektu->obszar_realizacji->id:' +obszar_realizacji.xpath("./*[local-name()='Id']").text
                # puts 'partnerzy->partner->miejsca_realizacji_projektu->obszar_realizacji->opis:' +obszar_realizacji.xpath("./*[local-name()='Opis']").text
                pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!( 
                  mrp_obszar_realizacji_id: obszar_realizacji.xpath("./*[local-name()='Id']").text,
                  mrp_obszar_realizacji_opis: obszar_realizacji.xpath("./*[local-name()='Opis']").text
                )  
              end #/obszar_realizacji
              miejsca_realizacji_projektu.xpath("./*[local-name()='MiejscaRealizacji']").each do |miejsca_realizacji|
                pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!(xml_miejsce_realizacji_tables_attributes: {})
                miejsca_realizacji.xpath("./*[local-name()='MiejsceRealizacji']").each_with_index do |miejsce_realizacji, miejsce_realizacji_index|
                  miejsce_realizacji.xpath("./*[local-name()='Wojewodztwo']").each do |wojewodztwo|
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->wojewodztwo->id:' +wojewodztwo.xpath("./*[local-name()='Id']").text
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->wojewodztwo->opis:' +wojewodztwo.xpath("./*[local-name()='Opis']").text                
                    pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"][:xml_miejsce_realizacji_tables_attributes].merge!("#{miejsce_realizacji_index}"=>{ 
                      wojewodztwo_id: wojewodztwo.xpath("./*[local-name()='Id']").text,
                      wojewodztwo_opis: wojewodztwo.xpath("./*[local-name()='Opis']").text
                    })  
                  end #/wojewodztwo                          
                  miejsce_realizacji.xpath("./*[local-name()='Powiat']").each do |powiat|
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->powiat->id:' +powiat.xpath("./*[local-name()='Id']").text
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->powiat->opis:' +powiat.xpath("./*[local-name()='Opis']").text                
                    pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"][:xml_miejsce_realizacji_tables_attributes]["#{miejsce_realizacji_index}"].merge!( 
                      powiat_id: powiat.xpath("./*[local-name()='Id']").text,
                      powiat_opis: powiat.xpath("./*[local-name()='Opis']").text
                    )  
                  end #/powiat                          
                  miejsce_realizacji.xpath("./*[local-name()='Gmina']").each do |gmina|
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->gmina->id:' +gmina.xpath("./*[local-name()='Id']").text
                    # puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->gmina->opis:' +gmina.xpath("./*[local-name()='Opis']").text                
                    pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"][:xml_miejsce_realizacji_tables_attributes]["#{miejsce_realizacji_index}"].merge!( 
                      gmina_id: gmina.xpath("./*[local-name()='Id']").text,
                      gmina_opis: gmina.xpath("./*[local-name()='Opis']").text
                    )  
                  end #/gmina                          
                  pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"][:xml_miejsce_realizacji_tables_attributes]["#{miejsce_realizacji_index}"].merge!( 
                    czy_na_terenie_calego_wojewodztwa: miejsce_realizacji.xpath("./*[local-name()='CzyNaTerenieCalegoWojewodztwa']").text,
                    czy_na_terenie_calego_powiatu: miejsce_realizacji.xpath("./*[local-name()='CzyNaTerenieCalegoPowiatu']").text
                  )  
         
                end #/miejsce_realizacji
              end #/miejsca_realizacji
              puts '-------------------------------------------------------------------------------------------------------------'
              puts 'partnerzy->partner->miejsca_realizacji_projektu->maksymalna_kwota_dofinansowania:' +miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaKwotaDofinansowania']").text
              puts 'partnerzy->partner->miejsca_realizacji_projektu->maksymalna_intensywnosc_wsparcia:' +miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaIntensywnoscWsparcia']").text
              puts '-------------------------------------------------------------------------------------------------------------'
              pf_attributes[:xml_partner_tables_attributes]["#{partner_index}"].merge!( 
                mrp_maksymalna_kwota_dofinansowania: miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaKwotaDofinansowania']").text,
                mrp_maksymalna_intensywnosc_wsparcia: miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaIntensywnoscWsparcia']").text
              )
            end #/miejsce_realizacji_projektu
          end #/partner
        end #/partnerzy

      end #/tresc_dokumentu
    end #/dokument

    # self.save
    # puts pf_attributes
    self.update(pf_attributes)
  end

end
