require 'rails_helper'

RSpec.describe PositionApplyController, type: :request do
  let(:user) { create(:user) }
  let(:position) { create(:position) }
  let(:valid_attributes) do
    {
      position: {
        position_id: position.id
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /position_apply/:id' do
    context 'with valid parameters' do
      it 'creates a job application' do
        expect do
          post position_apply_path, params: valid_attributes
        end.to change(JobApplication, :count).by(1)
      end

      it 'sets job application source to default' do
        post position_apply_path, params: valid_attributes

        expect(JobApplication.last.source).to eq('default')
      end

      it 'redirects to job application' do
        post position_apply_path, params: valid_attributes

        expect(response).to redirect_to(job_application_path(JobApplication.last.id))
      end

      it 'associates job application with user' do
        post position_apply_path, params: valid_attributes

        expect(JobApplication.last.user).to eq(user)
      end

      it 'renders flash message' do
        post position_apply_path, params: valid_attributes

        expect(flash[:notice]).to eq(I18n.t(:job_application_created_successfully))
      end
    end

    context 'when job application fails to save' do
      let(:full_messages) { instance_double(ActiveModel::Errors, full_messages: ['error']) }
      let(:job_application) { instance_double(JobApplication, save: false, errors: full_messages) }

      before do
        allow(JobApplication).to receive(:new).and_return(job_application)
      end

      it 'redirects to position path' do
        post position_apply_path, params: valid_attributes

        expect(response).to redirect_to(position_path(position))
      end

      it 'renders flash message' do
        post position_apply_path, params: valid_attributes

        expect(flash[:alert]).to eq('error')
      end
    end

    context 'with invalid parameters' do
      it 'redirects to postion path' do
        post position_apply_path, params: { position: { position_id: 0 } }

        expect(response).to redirect_to(root_path)
      end

      it 'renders flash message' do
        post position_apply_path, params: { position: { position_id: 0 } }

        expect(flash[:alert]).to eq(I18n.t(:position_not_found))
      end
    end
  end
end
