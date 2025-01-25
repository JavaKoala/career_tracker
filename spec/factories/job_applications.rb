FactoryBot.define do
  factory :job_application do
    applied { '2025-01-24' }
    accepted { '2025-01-25' }
    active { true }
    user
    position
  end
end
