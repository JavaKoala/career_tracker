require 'rails_helper'

RSpec.describe CoverLetterLlmService do
  let(:job_application) { create(:job_application, position: create(:position, name: 'Software Engineer')) }

  describe '#create_cover_letter' do
    context 'when the job application is present' do
      it 'creates a cover letter' do
        client = instance_double(OpenAI::Client, completions: { 'choices' => [{ 'text' => 'sample cover letter' }] })
        allow(OpenAI::Client).to receive(:new).and_return(client)
        cover_letter_llm_service = described_class.new(job_application.id, '0.5')

        cover_letter_llm_service.create_cover_letter

        expect(job_application.cover_letter).to be_attached
      end
    end

    context 'when the job application is not present' do
      it 'does not create a cover letter' do
        cover_letter_llm_service = described_class.new(0, '0.5')

        cover_letter_llm_service.create_cover_letter

        expect(job_application.cover_letter).not_to be_attached
      end
    end

    context 'when the llm is not enabled' do
      before do
        allow(Rails.configuration.openai).to receive(:[]).with(:enabled).and_return(false)
        allow(Rails.configuration.openai).to receive(:[]).with(:url).and_return('http://localhost:11434')
        allow(Rails.configuration.openai).to receive(:[]).with(:model).and_return('llama3.2:1b')
      end

      it 'does not create a cover letter' do
        client = instance_double(OpenAI::Client, completions: { 'choices' => [{ 'text' => 'sample cover letter' }] })
        allow(OpenAI::Client).to receive(:new).and_return(client)

        cover_letter_llm_service = described_class.new(job_application.id, '0.5')

        cover_letter_llm_service.create_cover_letter

        expect(job_application.cover_letter).not_to be_attached
      end
    end
  end

  describe '#cover_letter_prompt' do
    it 'returns the cover letter prompt' do
      cover_letter_llm_service = described_class.new(job_application.id, '0.5')
      prompt = cover_letter_llm_service.cover_letter_prompt

      expect(prompt).to match(
        "^You are applying for a #{job_application.position_name} position at #{job_application.company_name}."
      )
    end

    it 'returns a default prompt when the job application is not present' do
      cover_letter_llm_service = described_class.new(nil, '0.5')
      prompt = cover_letter_llm_service.cover_letter_prompt

      expect(prompt).to match('You are applying for a  position at .')
    end
  end

  describe '#llm_completions' do
    it 'returns the cover letter completions' do
      client = instance_double(OpenAI::Client, completions: { 'choices' => [{ 'text' => 'sample cover letter' }] })
      allow(OpenAI::Client).to receive(:new).and_return(client)

      cover_letter_llm_service = described_class.new(job_application.id, '0.5')

      expect(cover_letter_llm_service.llm_completions).to eq('sample cover letter')
    end

    it 'returns nil when the completions are not empty' do
      client = instance_double(OpenAI::Client, completions: {})
      allow(OpenAI::Client).to receive(:new).and_return(client)

      cover_letter_llm_service = described_class.new(job_application.id, '0.5')

      expect(cover_letter_llm_service.llm_completions).to be_nil
    end
  end
end
