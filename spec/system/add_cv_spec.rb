require 'rails_helper'

RSpec.describe 'Add CV', type: :system do # rubocop:disable RSpec/MultipleMemoizedHelpers
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
  let(:social_network1) { Faker::Lorem.word } # rubocop:disable RSpec/IndexedLet
  let(:social_username1) { Faker::Internet.username } # rubocop:disable RSpec/IndexedLet
  let(:social_network2) { Faker::Lorem.word } # rubocop:disable RSpec/IndexedLet
  let(:social_username2) { Faker::Internet.username } # rubocop:disable RSpec/IndexedLet
  let(:work_history_name1) { Faker::Company.name } # rubocop:disable RSpec/IndexedLet
  let(:work_history_position1) { Faker::Job.title } # rubocop:disable RSpec/IndexedLet
  let(:work_history_name2) { Faker::Company.name } # rubocop:disable RSpec/IndexedLet
  let(:work_history_position2) { Faker::Job.title } # rubocop:disable RSpec/IndexedLet

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
    click_on 'Add profile'
    fill_in 'Network', with: social_network1
    fill_in 'Username', with: social_username1
    click_on 'Add profile'
    all('[name="curriculum_vitae[resume][basics][profiles][][network]"]')[1].set(social_network2)
    all('[name="curriculum_vitae[resume][basics][profiles][][username]"]')[1].set(social_username2)
    click_on 'Add position'
    find('[name="curriculum_vitae[resume][work][][name]"]').set(work_history_name1)
    find('[name="curriculum_vitae[resume][work][][position]"]').set(work_history_position1)
    click_on 'Add position'
    all('[name="curriculum_vitae[resume][work][][name]"]')[1].set(work_history_name2)
    all('[name="curriculum_vitae[resume][work][][position]"]')[1].set(work_history_position2)

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
    expect(user.curriculum_vitae.resume['basics']['profiles'][0]['network']).to eq(social_network1)
    expect(user.curriculum_vitae.resume['basics']['profiles'][0]['username']).to eq(social_username1)
    expect(user.curriculum_vitae.resume['basics']['profiles'][1]['network']).to eq(social_network2)
    expect(user.curriculum_vitae.resume['basics']['profiles'][1]['username']).to eq(social_username2)
    expect(user.curriculum_vitae.resume['work'][0]['name']).to eq(work_history_name1)
    expect(user.curriculum_vitae.resume['work'][0]['position']).to eq(work_history_position1)
    expect(user.curriculum_vitae.resume['work'][1]['name']).to eq(work_history_name2)
    expect(user.curriculum_vitae.resume['work'][1]['position']).to eq(work_history_position2)
  end
end
