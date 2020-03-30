class ArchivizationType < ApplicationRecord

  ARCHIVIZATION_TYPE_ODCZYT = 1
  ARCHIVIZATION_TYPE_ODCZYT_ZAPIS = 2
  ARCHIVIZATION_TYPE_ODCZYT_ZAPIS_USUWANIE = 3
 
  # relations
  has_many :archivizations, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }



end
