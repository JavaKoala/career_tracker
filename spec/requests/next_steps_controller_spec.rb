require 'rails_helper'

RSpec.describe NextStepsController, type: :request do
  let(:job_application) { create(:job_application) }
  let(:valid_attributes) do
    {
      next_step: {
        description: 'Complete background check',
        due: 1.day.from_now,
        job_application_id: job_application.id
      }
    }
  end
  let(:invalid_attributes) do
    {
      next_step: {
        description: '     ',
        job_application_id: job_application.id
      }
    }
  end

  before do
    session = create(:session, user: job_application.user)
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  describe 'GET /next_steps' do
    it 'renders a successful response' do
      create(:next_step, job_application: job_application)

      get next_steps_path

      expect(response).to be_successful
    end
  end

  describe 'POST /next_steps' do
    context 'when the job application is not found' do
      it 'redirects to the root path' do
        post next_steps_path, params: { next_step: { job_application_id: 999 } }

        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash alert message' do
        post next_steps_path, params: { next_step: { job_application_id: 999 } }

        expect(flash[:alert]).to eq(I18n.t(:job_application_not_found))
      end
    end

    context 'when the job application belongs to a differet user' do
      it 'redirects to the root path' do
        job_application.update(user: create(:user, email_address: 'foo1@test.com'))

        post next_steps_path, params: valid_attributes

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with valid parameters' do
      it 'creates a new next step' do
        expect do
          post next_steps_path, params: valid_attributes
        end.to change(NextStep, :count).by(1)
      end

      it 'renders a success' do
        post next_steps_path(format: :turbo_stream), params: valid_attributes

        expect(response).to have_http_status(:success)
      end

      it 'renders a turbo stream' do
        post next_steps_path(format: :turbo_stream), params: valid_attributes

        expect(response.body).to include('turbo-stream')
      end
    end

    context 'with invalid parameters' do
      it 'renders a success' do
        post next_steps_path(format: :turbo_stream), params: invalid_attributes

        expect(response).to have_http_status(:success)
      end

      it 'does not create a new next step' do
        expect do
          post next_steps_path, params: invalid_attributes
        end.not_to change(NextStep, :count)
      end
    end
  end

  describe 'PATCH /next_steps/:id' do
    context 'when the next step is not found' do
      it 'redirects to the root path' do
        patch next_step_path(0, format: :turbo_stream), params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash alert message' do
        patch next_step_path(0, format: :turbo_stream), params: valid_attributes

        expect(flash[:alert]).to eq(I18n.t(:next_step_not_found))
      end
    end

    context 'when the job applications do not match' do
      let(:job_application1) do
        create(:job_application, position: job_application.position, user: job_application.user)
      end

      it 'does not update the job application' do
        valid_attributes[:next_step][:job_application_id] = job_application1.id
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        expect(next_step.reload.job_application_id).to eq(job_application.id)
      end
    end

    context 'when the job application belongs to a differet user' do
      it 'redirects to the root path' do
        next_step = create(:next_step, job_application: job_application)
        job_application.update(user: create(:user, email_address: 'test1@test.com'))

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash alert message' do
        next_step = create(:next_step, job_application: job_application)
        job_application.update(user: create(:user, email_address: 'test1@test.com'))

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        expect(flash[:alert]).to eq(I18n.t(:next_step_not_found))
      end
    end

    context 'with valid parameters' do
      it 'updates the next step' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        next_step.reload

        expect(next_step.description).to eq('Complete background check')
      end

      it 'returns a success response' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the next step' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step, format: :turbo_stream), params: invalid_attributes

        next_step.reload

        expect(next_step.description).not_to be_blank
      end

      it 'returns a success response' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step, format: :turbo_stream), params: valid_attributes

        expect(response).to have_http_status(:success)
      end

      it 'renders a alert on html format' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step), params: invalid_attributes

        expect(flash[:alert]).to eq("Description can't be blank")
      end

      it 'redirects on html format' do
        next_step = create(:next_step, job_application: job_application)

        patch next_step_path(next_step), params: invalid_attributes

        expect(response).to redirect_to(next_steps_path)
      end
    end
  end

  describe 'DELETE /next_steps/:id' do
    context 'when the next step is not found' do
      it 'redirects to the root path' do
        delete next_step_path(0, format: :turbo_stream)

        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash alert message' do
        delete next_step_path(0, format: :turbo_stream)

        expect(flash[:alert]).to eq(I18n.t(:next_step_not_found))
      end
    end

    context 'when the next step belongs to a different user' do
      it 'redirects to the root path' do
        next_step = create(:next_step, job_application: job_application)
        job_application.update(user: create(:user, email_address: 'test1@test.com'))

        delete next_step_path(next_step, format: :turbo_stream)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the next step can be deleted' do
      it 'destroys the requested next step' do
        next_step = create(:next_step, job_application: job_application)

        expect do
          delete next_step_path(next_step, format: :turbo_stream)
        end.to change(NextStep, :count).by(-1)
      end

      it 'returns a success response' do
        next_step = create(:next_step, job_application: job_application)

        delete next_step_path(next_step, format: :turbo_stream)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
