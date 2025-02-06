require 'rails_helper'

RSpec.describe InterviewerController, type: :request do
  let(:interview) { create(:interview) }
  let(:valid_attributes) do
    {
      interviewer: {
        person_attributes: {
          name: 'John Doe',
          email_address: 'test@test.com',
          company_id: interview.company.id
        },
        interview_id: interview.id
      }
    }
  end

  before do
    session = create(:session, user: interview.user)
    allow(Current).to receive_messages(session: session, user: interview.user)
  end

  describe 'POST /interviewer' do
    context 'with valid parameters' do
      it 'creates a new interviewer' do
        expect do
          post interviewer_index_path, params: valid_attributes
        end.to change(Interviewer, :count).by(1)
      end

      it 'redirects to the interview path' do
        post interviewer_index_path, params: valid_attributes

        expect(response).to redirect_to(interview_path(interview))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          interviewer: {
            person_attributes: {
              name: '    ',
              email_address: 'test@test.com',
              company_id: interview.company.id
            },
            interview_id: interview.id
          }
        }
      end

      it 'does not create a new interviewer' do
        expect do
          post interviewer_index_path, params: invalid_attributes
        end.not_to change(Interviewer, :count)
      end

      it 'redirects to the interview path' do
        post interviewer_index_path, params: invalid_attributes

        expect(response).to redirect_to(interview_path(interview))
      end

      it 'displays an error message' do
        post interviewer_index_path, params: invalid_attributes

        expect(flash[:alert]).to eq("Person name can't be blank")
      end
    end

    context 'with an invalid interview' do
      let(:invalid_attributes) do
        {
          interviewer: {
            person_attributes: {
              name: 'John Doe',
              email_address: ''
            },
            interview_id: 0
          }
        }
      end

      it 'redirects to the root path' do
        post interviewer_index_path, params: invalid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'displays an error message' do
        post interviewer_index_path, params: invalid_attributes

        expect(flash[:alert]).to eq('Interview not found')
      end
    end

    context 'when the interview does not belong to the current user' do
      let(:user2) { create(:user, email_address: 'test@test.com') }

      before do
        allow(Current).to receive_messages(user: user2)
      end

      it 'redirects to the root path' do
        post interviewer_index_path, params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'displays an error message' do
        post interviewer_index_path, params: valid_attributes

        expect(flash[:alert]).to eq('Interview not found')
      end
    end
  end
end
