require 'rails_helper'

RSpec.describe 'Add CV', type: :system do
  let(:user) { create(:user) }
  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }

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

    expect do
      click_on 'Create resume'

      expect(page).to have_content('CV')
    end.to change(CurriculumVitae, :count).by(1)

    expect(user.curriculum_vitae.resume['basics']['name']).to eq(name)
    expect(user.curriculum_vitae.resume['basics']['email']).to eq(email)
  end
end
