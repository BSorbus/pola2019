class XmlProjektTable < ApplicationRecord
  belongs_to :proposal_file

  has_many :xml_wskaznik_tables, dependent: :delete_all, index_errors: true
  has_many :xml_wybrana_technologia_tables, dependent: :delete_all, index_errors: true
  has_many :xml_zadanie_tables, dependent: :destroy, index_errors: true
  has_many :xml_kamien_milowy_tables, through: :xml_zadanie_tables

  accepts_nested_attributes_for :xml_wskaznik_tables, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :xml_wybrana_technologia_tables, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :xml_zadanie_tables, reject_if: :all_blank, allow_destroy: true

end
