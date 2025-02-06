class Interviewer < ApplicationRecord
  belongs_to :person
  belongs_to :interview

  accepts_nested_attributes_for :person

  delegate :name, to: :person
  delegate :email_address, to: :person
end
