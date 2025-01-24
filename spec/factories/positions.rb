FactoryBot.define do
  factory :position do
    name { 'Software Engineer' }
    description { 'Job description' }
    pay_start { 100_000 }
    pay_end { 120_000 }
    company
  end
end
