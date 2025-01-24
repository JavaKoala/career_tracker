FactoryBot.define do
  factory :user do
    email_address { 'foo@test.com' }
    password { 'password' }
  end
end
