class Position < ApplicationRecord
  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :job_applications, dependent: :destroy

  enum :location, { office: 0, hybrid: 1, remote: 2 }, default: :office, validate: true

  validates :name, presence: true
  validates :description, presence: true
end
