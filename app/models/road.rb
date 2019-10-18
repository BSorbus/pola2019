class Road < ApplicationRecord

  # relations
  belongs_to :business_trip
  belongs_to :transport_type

  # validates
  validates :from, presence: true,
                    length: { in: 1..100 }
  validates :to, presence: true,
                    length: { in: 1..100 }
  validate :end_after_start
  validates :start_date_time, presence: true
  validates :end_date_time, presence: true

  validates :transport_type, presence: true




  private

    def end_after_start
      return if end_date_time.blank? || start_date_time.blank?
     
      if end_date_time < start_date_time
        errors.add(:end_date_time, 'nie może być wcześniejsza od daty i godziny wyjazdu') 
        throw :abort 
      end 
    end

end
