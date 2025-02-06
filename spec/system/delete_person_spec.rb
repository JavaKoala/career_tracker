require 'rails_helper'

RSpec.describe 'Delete Person', type: :system do
  let(:person) { create(:person) }
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'deletes a person' do
    visit company_path(person.company)

    click_on "person-#{person.id}-delete"

    expect do
      click_on 'Delete person'
      expect(page).to have_content('Deleted person')
      expect(page).to have_no_content(person.name)
    end.to change(Person, :count).by(-1)
  end
end
