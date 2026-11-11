require 'rails_helper'

RSpec.describe 'Add CV', type: :system do
  let(:user) { create(:user) }
  let(:name) { Faker::Name.name }
  let(:label) { Faker::Job.title }
  let(:image) { Faker::Internet.url(host: 'example.com', path: '/image.jpg') }
  let(:email) { Faker::Internet.email }
  let(:phone) { Faker::PhoneNumber.phone_number }
  let(:summary) { Faker::Lorem.paragraph(sentence_count: 3) }
  let(:address) { Faker::Address.street_address }
  let(:postal_code) { Faker::Address.postcode }
  let(:city) { Faker::Address.city }
  let(:country_code) { Faker::Address.country_code }
  let(:state) { Faker::Address.state }

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'creates a new resume' do
    visit root_path

    click_on 'Settings'
    click_on 'Resume'

    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Label', with: label
    fill_in 'Image', with: image
    fill_in 'Phone', with: phone
    fill_in 'Summary', with: summary
    fill_in 'Address', with: address
    fill_in 'Postal Code', with: postal_code
    fill_in 'City', with: city
    fill_in 'Country Code', with: country_code
    fill_in 'Region', with: state

    expect do
      click_on 'Create resume'

      expect(page).to have_content('CV')
    end.to change(CurriculumVitae, :count).by(1)

    expect(user.curriculum_vitae.resume['basics']['name']).to eq(name)
    expect(user.curriculum_vitae.resume['basics']['email']).to eq(email)
    expect(user.curriculum_vitae.resume['basics']['label']).to eq(label)
    expect(user.curriculum_vitae.resume['basics']['image']).to eq(image)
    expect(user.curriculum_vitae.resume['basics']['phone']).to eq(phone)
    expect(user.curriculum_vitae.resume['basics']['summary']).to eq(summary)
    expect(user.curriculum_vitae.resume['basics']['location']['address']).to eq(address)
    expect(user.curriculum_vitae.resume['basics']['location']['postalCode']).to eq(postal_code)
    expect(user.curriculum_vitae.resume['basics']['location']['city']).to eq(city)
    expect(user.curriculum_vitae.resume['basics']['location']['countryCode']).to eq(country_code)
    expect(user.curriculum_vitae.resume['basics']['location']['region']).to eq(state)
  end
end
