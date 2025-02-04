class Interview < ApplicationRecord
  belongs_to :job_application

  delegate :user, to: :job_application, prefix: true

  validates :interview_start, :interview_end, :location, presence: true
  validate :end_after_start

  def end_after_start
    return if interview_end.blank? || interview_start.blank?

    errors.add(:interview_end, "can't be before start") if interview_end < interview_start
  end
end
