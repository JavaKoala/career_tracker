class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :position

  accepts_nested_attributes_for :position

  validates :source, presence: true

  delegate :name, to: :position, prefix: true
  delegate :description, to: :position, prefix: true
  delegate :pay_start, to: :position, prefix: true
  delegate :pay_end, to: :position, prefix: true
  delegate :company, to: :position
  delegate :name, to: :company, prefix: true
  delegate :friendly_name, to: :company, prefix: true
  delegate :description, to: :company, prefix: true

  before_create { self.applied = Date.current }
end
