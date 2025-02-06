class Interview < ApplicationRecord
  belongs_to :job_application
  has_many :interview_questions, dependent: :destroy
  has_many :interviewers, dependent: :destroy

  delegate :user, to: :job_application
  delegate :company, to: :job_application

  validates :interview_start, :interview_end, :location, presence: true
  validate :end_after_start

  def end_after_start
    return if interview_end.blank? || interview_start.blank?

    errors.add(:interview_end, "can't be before start") if interview_end < interview_start
  end
end
