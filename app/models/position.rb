class Position < ApplicationRecord
  belongs_to :company
  has_many :job_applications, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
