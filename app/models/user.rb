class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_one_attached :job_application_export
  has_one_attached :job_application_import

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def active_applications
    job_applications.where(active: true).order(created_at: :desc)
  end
end
