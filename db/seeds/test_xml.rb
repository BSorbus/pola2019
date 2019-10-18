puts " "
puts "#####  RUN - test_XML.rb  #####"
puts " "

# doc = Nokogiri::XML(File.open("db/seeds/wniosek.xml")) do |config|
#   config.strict.nonet
# end

# # puts '------------------------------------------'
#   doc.remove_namespaces! # Remove namespaces from xml to make it clean
#   print doc
# # puts '------------------------------------------'




doc = Nokogiri::XML(File.open("db/seeds/wniosek.xml")) do |config|
  config.strict.nonet
end

#  doc.remove_namespaces! # Remove namespaces from xml to make it clean
#  print doc

doc.xpath("//*[local-name()='Dokument']").each do |dokument|
  dokument.xpath("//*[local-name()='TrescDokumentu']").each do |tresc_dokumentu|

    tresc_dokumentu.xpath("./*[local-name()='Wniosek']").each do |wniosek|
      wniosek.xpath("./*[local-name()='Nabor']").each do |nabor|
        puts 'wniosek->nabór->id:' +nabor.xpath("./*[local-name()='Id']").text
        puts 'wniosek->nabór->opis:' +nabor.xpath("./*[local-name()='Opis']").text
      end #/nabor
      wniosek.xpath("./*[local-name()='Rodzaj']").each do |rodzaj|
        puts 'wniosek->rodzaj->id:' +rodzaj.xpath("./*[local-name()='Id']").text
        puts 'wniosek->rodzaj->opis:' +rodzaj.xpath("./*[local-name()='Opis']").text
      end #rodzaj
    end #/wniosek

    tresc_dokumentu.xpath("./*[local-name()='Partnerzy']").each do |partnerzy|
      partnerzy.xpath("./*[local-name()='Partner']").each do |partner|
        partner.xpath("./*[local-name()='DanePodmiotu']").each do |dane_podmiotu|
          puts 'partnerzy->partner->dane_podmiotu->nazwa:' +dane_podmiotu.xpath("./*[local-name()='Nazwa']").text
          puts 'partnerzy->partner->dane_podmiotu->nip:' +dane_podmiotu.xpath("./*[local-name()='NIP']").text
          puts 'partnerzy->partner->dane_podmiotu->regon:' +dane_podmiotu.xpath("./*[local-name()='REGON']").text
          dane_podmiotu.xpath("./*[local-name()='AdresSiedziby']").each do |adres_siedziby|
            adres_siedziby.xpath("./*[local-name()='Miejscowosc']").each do |miejscowosc|
              puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->miejscowosc->id:' +miejscowosc.xpath("./*[local-name()='Id']").text
              puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->miejscowosc->opis:' +miejscowosc.xpath("./*[local-name()='Opis']").text
            end #/miejscowosc
            puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->kod_pocztowy:' +adres_siedziby.xpath("./*[local-name()='KodPocztowy']").text
            adres_siedziby.xpath("./*[local-name()='Ulica']").each do |ulica|
              puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->ulica->id:' +ulica.xpath("./*[local-name()='Id']").text
              puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->ulica->opis:' +ulica.xpath("./*[local-name()='Opis']").text
            end #/ulica
            puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->nr:' +adres_siedziby.xpath("./*[local-name()='Nr']").text
            puts 'partnerzy->partner->dane_podmiotu->adres_siedziby->lokal:' +adres_siedziby.xpath("./*[local-name()='Lokal']").text
          end #/adres_siedziny
        end #/dane_podmiotu
        puts 'partnerzy->partner->numer_wpisu_uke:' +partner.xpath("./*[local-name()='NumerWpisuUKE']").text
        partner.xpath("./*[local-name()='MiejscaRealizacjiProjektu']").each do |miejsca_realizacji_projektu|
          miejsca_realizacji_projektu.xpath("./*[local-name()='ObszarRealizacji']").each do |obszar_realizacji|
            puts 'partnerzy->partner->miejsca_realizacji_projektu->obszar_realizacji->id:' +obszar_realizacji.xpath("./*[local-name()='Id']").text
            puts 'partnerzy->partner->miejsca_realizacji_projektu->obszar_realizacji->opis:' +obszar_realizacji.xpath("./*[local-name()='Opis']").text
          end #/obszar_realizacji
          miejsca_realizacji_projektu.xpath("./*[local-name()='MiejscaRealizacji']").each do |miejsca_realizacji|
            miejsca_realizacji.xpath("./*[local-name()='MiejsceRealizacji']").each do |miejsce_realizacji|
              miejsce_realizacji.xpath("./*[local-name()='Wojewodztwo']").each do |wojewodztwo|
                puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->wojewodztwo->id:' +wojewodztwo.xpath("./*[local-name()='Id']").text
                puts 'partnerzy->partner->miejsca_realizacji_projektu->miejsca_realizacji->miejsce_realizacji->wojewodztwo->opis:' +wojewodztwo.xpath("./*[local-name()='Opis']").text                
              end #/wojewodztwo                          
            end #/miejsce_realizacji
          end #/miejsca_realizacji
          puts 'partnerzy->partner->miejsca_realizacji_projektu->maksymalna_kwota_dofinansowania:' +miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaKwotaDofinansowania']").text
          puts 'partnerzy->partner->miejsca_realizacji_projektu->maksymalna_intensywnosc_wsparcia:' +miejsca_realizacji_projektu.xpath("./*[local-name()='MaksymalnaIntensywnoscWsparcia']").text
        end #/miejsce_realizacji_projektu
      end #/partner
    end #/partnerzy

    tresc_dokumentu.xpath("./*[local-name()='Projekt']").each do |projekt|
      projekt.xpath("./*[local-name()='DaneOgolne']").each do |dane_ogolne|
        puts 'projekt->dane_ogolne->tytul:' +dane_ogolne.xpath("./*[local-name()='Tytul']").text
        dane_ogolne.xpath("./*[local-name()='OkresRealizacji']").each do |okres_realizacji|
          puts 'projekt->dane_ogolne->okres_realizacji->DataOd:' +okres_realizacji.xpath("./*[local-name()='DataOd']").text
          puts 'projekt->dane_ogolne->okres_realizacji->DataDo:' +okres_realizacji.xpath("./*[local-name()='DataDo']").text
        end #/okres_realizacji
        dane_ogolne.xpath("./*[local-name()='OkresKwalifikowalnosciWydatkow']").each do |okres_kwalifikowalnosci_wydatkow|
          puts 'projekt->dane_ogolne->okres_kwalifikowalnosci_wydatkow->DataOd:' +okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataOd']").text
          puts 'projekt->dane_ogolne->okres_kwalifikowalnosci_wydatkow->DataOd:' +okres_kwalifikowalnosci_wydatkow.xpath("./*[local-name()='DataDo']").text
        end #/okres_kwalifikowalnosci_wydatkow
        dane_ogolne.xpath("./*[local-name()='TechnologieRealizacjiProjektu']").each do |technologie_realizacji_projektu|
          technologie_realizacji_projektu.xpath("./*[local-name()='WybraneTechnologie']").each do |wybrane_technologie|
            wybrane_technologie.xpath("./*[local-name()='Element']").each do |element|
              puts 'projekt->dane_ogolne->technologie_realizacji_projektu->wybrane_technologie->element-id:' +element.xpath("./*[local-name()='Id']").text
              puts 'projekt->dane_ogolne->technologie_realizacji_projektu->wybrane_technologie->element-opis:' +element.xpath("./*[local-name()='Opis']").text
            end #/element
          end #/wybrane_technologie
          technologie_realizacji_projektu.xpath("./*[local-name()='InnaTechnologia']").each do |inna_technologia|
            puts 'projekt->dane_ogolne->technologie_realizacji_projektu->inna_technologia->??????????????????????????????:'
          end #/wybrane_technologie
        end #/technologie_realizacji_projektu
      end #/ogolne_dane

      projekt.xpath("./*[local-name()='WskaznikiMierzalneOgolne']").each do |wskazniki_mierzalne_ogolne|
        wskazniki_mierzalne_ogolne.xpath("./*[local-name()='WskaznikiMierzalne']").each do |wskazniki_mierzalne|
          wskazniki_mierzalne.xpath("./*[local-name()='Wskaznik']").each do |wskaznik|
            puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->numer:' +wskaznik.xpath("./*[local-name()='Numer']").text
            wskaznik.xpath("./*[local-name()='Nazwa']").each do |nazwa|
              puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->id:' +nazwa.xpath("./*[local-name()='Id']").text
              puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->kod:' +nazwa.xpath("./*[local-name()='Kod']").text
              puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->nazwa->opis:' +nazwa.xpath("./*[local-name()='Opis']").text
            end
            puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->typ:' +wskaznik.xpath("./*[local-name()='Typ']").text
            puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->JednostkaMiary->opis:' +wskaznik.xpath("./*[local-name()='JednostkaMiary']").xpath("./*[local-name()='Opis']").text
            puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->wartosc_docelowa:' +wskaznik.xpath("./*[local-name()='WartoscDocelowa']").text
            puts 'projekt->wskazniki_mierzalne_ogolne->wskaznik->czy_wlasny:' +wskaznik.xpath("./*[local-name()='CzyWlasny']").text
          end #/wskaznik
        end #/wskazniki_mierzalne
      end #/wskazniki_mierzalne_ogolne

      projekt.xpath("./*[local-name()='ZakresRzeczowy']").each do |zakres_rzeczowy|
        zakres_rzeczowy.xpath("./*[local-name()='Zadania']").each do |zadania|
          zadania.xpath("./*[local-name()='Zadanie']").each do |zadanie|
            puts 'projekt->zakres_rzeczowy->zadania->zadanie->zadanie:' +zadanie.xpath("./*[local-name()='Zadanie']").text
            puts 'projekt->zakres_rzeczowy->zadania->zadanie->nr_zadania:' +zadanie.xpath("./*[local-name()='NumerZadania']").text
            puts 'projekt->zakres_rzeczowy->zadania->zadanie->nr_zadania:' +zadanie.xpath("./*[local-name()='Nazwa']").text

            zadanie.xpath("./*[local-name()='InformacjeDoKamieniMilowych']").each do |informacje_do_kamieni_milowych|
              puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->data_rozpoczecia:' +informacje_do_kamieni_milowych.xpath("./*[local-name()='DataRozpoczecia']").text
              puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->planowana_data_zakonczenia:' +informacje_do_kamieni_milowych.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text
  
              informacje_do_kamieni_milowych.xpath("./*[local-name()='KamienieMilowe']").each do |kamienie_milowe|
                kamienie_milowe.xpath("./*[local-name()='KamienMilowy']").each do |kamien_milowy|
                  puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->nazwa:' +kamien_milowy.xpath("./*[local-name()='Nazwa']").text
                  puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->czy_oznacza_zakonczenie_zadania:' +kamien_milowy.xpath("./*[local-name()='CzyOznaczaZakonczenieZadania']").text
                  puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->planowana_data_zakonczenia:' +kamien_milowy.xpath("./*[local-name()='PlanowanaDataZakonczenia']").text
                  puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->data_punktu_krytycznego:' +kamien_milowy.xpath("./*[local-name()='DataPunktuKrytycznego']").text
                  puts 'projekt->zakres_rzeczowy->zadania->zadanie->informacje_do_kamieni_milowych->kamienie_milowe->kamien_milowy->data_punktu_ostatecznego:' +kamien_milowy.xpath("./*[local-name()='DataPunktuOstatecznego']").text
                end #kamien_milowy
              end #kamienie_milowe

            end #/informacje_do_kamieni_milowych
          end #/zadanie
        end #zadania
      end #/zakres_rzeczowy

      projekt.xpath("./*[local-name()='MontazFinansowyProjektu']").each do |montaz_finansowy_projektu|
        montaz_finansowy_projektu.xpath("./*[local-name()='MontazFinansowyOgolem']").each do |montaz_finansowy_ogolem|
          montaz_finansowy_ogolem.xpath("./*[local-name()='MontazFinansowy']").each do |montaz_finansowy|
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wydatki_ogolem:' +montaz_finansowy.xpath("./*[local-name()='WydatkiOgolem']").text  

            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wydatki_kwalifikowane:' +montaz_finansowy.xpath("./*[local-name()='WydatkiKwalifikowane']").text  
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->dofinansowanie:' +montaz_finansowy.xpath("./*[local-name()='Dofinansowanie']").text  
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->procent_dofinansowania:' +montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowania']").text  
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wklad_ue:' +montaz_finansowy.xpath("./*[local-name()='WkladUE']").text  
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->procent_dofinansowania_ue:' +montaz_finansowy.xpath("./*[local-name()='ProcentDofinansowaniaUE']").text  
            puts 'projekt->montaz_finansowy_projektu->montaz_finansowy_ogolem->montaz_finansowy->wklad_wlasny:' +montaz_finansowy.xpath("./*[local-name()='WkladWlasny']").text  

          end #/montaz_finansowy
        end #/montaz_finansowy_ogolem        
      end #/montaz_finansowy_projektu
    end #/projekt    
  end #/tresc_dokumentu
end #/dokument



puts " "
puts "#####  END OF - test_XML.rb  #####"
puts " "


