class Position < ApplicationRecord
  belongs_to :company
  validates :name, presence: true
  validates :description, presence: true
end
