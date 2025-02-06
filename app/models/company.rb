class Company < ApplicationRecord
  has_many :positions, dependent: :destroy
  has_many :people, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
