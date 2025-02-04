FactoryBot.define do
  factory :interview do
    interview_start { '2025-02-03 12:31:41' }
    interview_end { '2025-02-03 12:31:41' }
    location { 'Online' }
    job_application
  end
end
