class NextStep < ApplicationRecord
  belongs_to :job_application

  validates :description, presence: true

  delegate :user, to: :job_application

  scope :due_today, lambda { |user|
    joins(job_application: :user).where(
      'users.id = ? AND job_applications.active = ? AND due = ? AND done = ?',
      user, true, Date.current, false
    )
  }

  scope :past_due, lambda { |user|
    joins(job_application: :user).where(
      'users.id = ? AND job_applications.active = ? AND due < ? AND done = ?',
      user, true, Date.current, false
    )
  }
end
