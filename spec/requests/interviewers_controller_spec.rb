require 'rails_helper'

RSpec.describe InterviewersController, type: :request do
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

  describe 'POST /interviewers' do
    context 'with valid parameters' do
      it 'creates a new interviewer' do
        expect do
          post interviewers_path, params: valid_attributes
        end.to change(Interviewer, :count).by(1)
      end

      it 'redirects to the interview path' do
        post interviewers_path, params: valid_attributes

        expect(response).to redirect_to(interview_path(interview))
      end

      it 'sets the person if provided' do
        person2 = create(:person, company: interview.company)
        valid_attributes[:interviewer][:person_id] = person2.id

        post interviewers_path, params: valid_attributes

        expect(Interviewer.last.person.id).to eq(person2.id)
      end

      it 'does not set the user if invalid' do
        valid_attributes[:interviewer][:person_id] = 0

        expect do
          post interviewers_path, params: valid_attributes
        end.to change(Interviewer, :count).by(1)
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
          post interviewers_path, params: invalid_attributes
        end.not_to change(Interviewer, :count)
      end

      it 'redirects to the interview path' do
        post interviewers_path, params: invalid_attributes

        expect(response).to redirect_to(interview_path(interview))
      end

      it 'displays an error message' do
        post interviewers_path, params: invalid_attributes

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
        post interviewers_path, params: invalid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'displays an error message' do
        post interviewers_path, params: invalid_attributes

        expect(flash[:alert]).to eq('Interview not found')
      end
    end

    context 'when the interview does not belong to the current user' do
      let(:user2) { create(:user, email_address: 'test@test.com') }

      before do
        allow(Current).to receive_messages(user: user2)
      end

      it 'redirects to the root path' do
        post interviewers_path, params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'displays an error message' do
        post interviewers_path, params: valid_attributes

        expect(flash[:alert]).to eq('Interview not found')
      end
    end
  end

  describe 'DELETE /interviewers/:id' do
    let(:person) { create(:person, company: interview.company) }

    context 'when the interview does not belong to the current user' do
      let(:user2) { create(:user, email_address: 'test@test.com') }

      before do
        allow(Current).to receive(:user).and_return(user2)
      end

      it 'redirects to the root path' do
        interviewer = create(:interviewer, interview: interview, person: person)

        delete interviewer_path(interviewer)

        expect(response).to redirect_to(root_path)
      end

      it 'does not delete the interviewer' do
        interviewer = create(:interviewer, interview: interview, person: person)

        expect do
          delete interviewer_path(interviewer)
        end.not_to change(Interviewer, :count)
      end

      it 'renders flash message' do
        interviewer = create(:interviewer, interview: interview, person: person)

        delete interviewer_path(interviewer)

        expect(flash[:alert]).to eq('Interviewer not found')
      end
    end

    context 'when the inerviewer is not found' do
      it 'redirects to the root path' do
        delete interviewer_path(0)

        expect(response).to redirect_to(root_path)
      end

      it 'does not delete the interviewer' do
        expect do
          delete interviewer_path(0)
        end.not_to change(Interviewer, :count)
      end

      it 'displays an error message' do
        delete interviewer_path(0)

        expect(flash[:alert]).to eq('Interviewer not found')
      end
    end

    context 'when the interviewer is found' do
      it 'destroys the requested interviewer' do
        interviewer = create(:interviewer, interview: interview, person: person)

        expect do
          delete interviewer_path(interviewer)
        end.to change(Interviewer, :count).by(-1)
      end

      it 'redirects to the interview path' do
        interviewer = create(:interviewer, interview: interview, person: person)

        delete interviewer_path(interviewer)

        expect(response).to redirect_to(interview_path(interview))
      end

      it 'renders flash message' do
        interviewer = create(:interviewer, interview: interview, person: person)

        delete interviewer_path(interviewer)

        expect(flash[:notice]).to eq('Deleted interviewer')
      end
    end
  end
end
