class InterviewQuestion < ApplicationRecord
  belongs_to :interview

  delegate :user, to: :interview

  validates :question, presence: true
end
