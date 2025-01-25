class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :position

  accepts_nested_attributes_for :position
  accepts_nested_attributes_for :user
end
