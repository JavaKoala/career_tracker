FactoryBot.define do
  factory :company do
    name { 'Company Name' }
    friendly_name { 'Test Company' }
    address1 { 'Test Street 1' }
    address2 { 'Suite 200' }
    city { 'Test City' }
    state { 'Test State' }
    county { 'Test County' }
    zip { '90210' }
    country { 'USA' }
    description { 'This is a test company' }
  end
end
