class CurriculumVitae < ApplicationRecord
  JSON_RESUME_SCHEMA = Rails.root.join('config/schemas/jsonresume.org/schema.json')

  belongs_to :user

  validates :resume, presence: true, json: { schema: JSON_RESUME_SCHEMA }
end
