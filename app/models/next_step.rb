class NextStep < ApplicationRecord
  belongs_to :job_application

  validates :description, presence: true
end
