class Company < ApplicationRecord
  has_many :positions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
