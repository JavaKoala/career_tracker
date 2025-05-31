class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_one_attached :job_application_export
  has_one_attached :job_application_import

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validate :correct_job_application_import_mime_type

  def active_applications
    job_applications.where(active: true).order(created_at: :desc)
  end

  def correct_job_application_import_mime_type
    return unless job_application_import.attached? && job_application_import.content_type != 'text/csv'

    errors.add(:job_application_import, 'must be a CSV file')
  end
end
