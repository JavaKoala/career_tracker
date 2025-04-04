require 'rails_helper'

RSpec.describe 'Add Job Application', type: :system do
  before do
    user = create(:user)
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'creates a new job application' do
    visit root_path

    click_on 'New application'

    fill_in 'Source', with: 'LinkedIn'
    fill_in 'Job title', with: 'Developer'
    find('trix-editor').click.set('A developer role')
    fill_in 'Pay start', with: '50000'
    fill_in 'Pay end', with: '100000'
    choose(option: 'remote')
    fill_in 'Company name', with: 'Acme'
    fill_in 'Friendly name', with: 'Acme Inc.'
    fill_in 'Company description', with: 'A company'

    expect do
      click_on 'Add application'

      expect(page).to have_no_content('Add application')
      expect(page).to have_content('Job application created successfully')
      expect(page).to have_content('Developer')
      expect(page).to have_content('Acme')
    end.to change(JobApplication, :count).by(1)
  end

  it 'shows an error message on invalid job application' do
    visit root_path

    click_on 'New application'

    fill_in 'Source', with: 'LinkedIn'
    fill_in 'Job title', with: '    '
    find('trix-editor').click.set('A developer role')
    fill_in 'Company name', with: 'Acme'

    expect do
      click_on 'Add application'

      expect(page).to have_no_content('Add application')
      expect(page).to have_content("Position name can't be blank")
    end.not_to change(JobApplication, :count)
  end

  it 'closes the form when close is clicked' do
    visit root_path

    click_on 'New application'
    click_on 'Close'

    expect(page).to have_no_content('Add application')
  end

  context 'when applying from position' do
    it 'creates a new job application' do
      position = create(:position)

      visit position_path(position)

      expect do
        click_on 'Apply'

        expect(page).to have_content('Job application created successfully')
      end.to change(JobApplication, :count).by(1)

      visit position_path(position)

      expect(page).to have_no_content('Apply')
    end
  end
end
