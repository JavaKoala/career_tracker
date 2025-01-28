class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :job_applications, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def active_applications
    job_applications.where(active: true)
  end
end
