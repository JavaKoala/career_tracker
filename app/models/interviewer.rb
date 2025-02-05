class Interviewer < ApplicationRecord
  belongs_to :person
  belongs_to :interview
end
