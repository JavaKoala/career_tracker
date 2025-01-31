class Position < ApplicationRecord
  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :job_applications, dependent: :destroy

  enum :location, { office: 0, hybrid: 1, remote: 2 }, default: :office, validate: true

  validates :name, presence: true
  has_rich_text :description

  def already_applied?(user)
    job_applications.exists?(user: user)
  end
end
