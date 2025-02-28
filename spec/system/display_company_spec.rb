require 'rails_helper'

RSpec.describe 'Display Company', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:company) { create(:company) }
  let(:position) { create(:position, company: company) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'displays a company' do
    job_application = create(:job_application, position: position, user: user)

    visit root_path

    click_on job_application.company_name

    expect(page).to have_no_content('>')

    expect(page).to have_content(company.name)
    expect(page).to have_content(company.friendly_name)
    expect(page).to have_content(company.address1)
    expect(page).to have_content(company.address2)
    expect(page).to have_content(company.city)
    expect(page).to have_content(company.state)
    expect(page).to have_content(company.county)
    expect(page).to have_content(company.zip)
    expect(page).to have_content(company.country)
    expect(page).to have_content(company.description)
    expect(page).to have_content(position.name)
  end

  it 'displays company through index' do
    company

    visit companies_path

    expect(page).to have_content(company.name)

    click_on company.name

    expect(page).to have_content(company.description)
  end

  it 'displays companies through home link' do
    company

    visit root_path

    click_on 'Companies'

    expect(page).to have_content(company.name)
  end

  it 'displays paginated companies' do
    build_list(:company, 30).each do |company|
      company.name = SecureRandom.uuid
      company.save!
    end

    visit companies_path

    expect(page).to have_content(Company.order(name: :asc).first.name)

    click_on '>'

    expect(page).to have_no_content(Company.order(name: :asc).first.name)

    visit companies_path

    expect(page).to have_content(Company.order(name: :asc).first.name)

    click_on 'Company'

    expect(page).to have_no_content(Company.order(name: :asc).first.name)

    click_on 'Company'

    expect(page).to have_content(Company.order(name: :asc).first.name)
  end

  it 'searches companies' do
    company
    create(:company, name: 'Another Company')

    visit companies_path

    fill_in 'name', with: 'Another'

    click_on 'Search'

    expect(page).to have_content('Another Company')
    expect(page).to have_no_content(company.name)
  end
end
