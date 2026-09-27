FactoryBot.define do
  factory :curriculum_vitae do
    resume { { 'basics' => { 'name' => 'John Doe' } } }
    user
  end
end
