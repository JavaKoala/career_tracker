require 'rails_helper'

RSpec.describe 'Delete Next Step', type: :system do
  let(:next_step) { create(:next_step) }
  let(:session) { create(:session, user: next_step.user) }

  before do
    allow(Current).to receive_messages(session: session, user: next_step.user)
  end

  it 'deletes a next step' do
    visit job_application_path(next_step.job_application)

    click_on "next-step-#{next_step.id}-delete"

    expect do
      click_on 'Delete next step'
      expect(page).to have_no_content(next_step.description)
    end.to change(NextStep, :count).by(-1)
  end
end
