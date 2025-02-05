class Person < ApplicationRecord
  belongs_to :company

  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
