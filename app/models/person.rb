class Person < ApplicationRecord
  belongs_to :company
  has_many :interviewers, dependent: :destroy

  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
