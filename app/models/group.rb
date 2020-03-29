class Group < ApplicationRecord
  include ActionView::Helpers::TextHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  has_and_belongs_to_many :users
  # has_many :accessorizations, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }


  def fullname
    "#{name}"
  end

  def name_as_link
    "<a href=#{url_helpers.group_path(self)}>#{self.name}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end

end
