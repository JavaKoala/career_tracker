class Interview < ApplicationRecord
  belongs_to :job_application
  has_many :interview_questions, dependent: :destroy
  has_many :interviewers, dependent: :destroy

  delegate :user, to: :job_application
  delegate :company, to: :job_application
  delegate :next_steps, to: :job_application
  delegate :next_steps_ordered, to: :job_application

  validates :interview_start, :interview_end, :location, presence: true
  validate :end_after_start

  after_create :create_home_calendar_event
  after_update :update_home_calendar_event
  after_destroy :delete_home_calendar_event

  def end_after_start
    return if interview_end.blank? || interview_start.blank?

    errors.add(:interview_end, "can't be before start") if interview_end < interview_start
  end

  def create_home_calendar_event
    return unless Rails.application.config.home_calendar[:enabled]

    CreateHomeCalendarInterviewEventJob.perform_later(id)
  end

  def delete_home_calendar_event
    return unless Rails.application.config.home_calendar[:enabled] && home_calendar_event_id.present?

    DeleteHomeCalendarInterviewEventJob.perform_later(home_calendar_event_id)
  end

  def update_home_calendar_event
    return unless Rails.application.config.home_calendar[:enabled] && home_calendar_event_id.present?

    UpdateHomeCalendarInterviewEventJob.perform_later(id)
  end
end
