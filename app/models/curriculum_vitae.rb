class CurriculumVitae < ApplicationRecord
  belongs_to :user

  validates :resume, presence: true
end
