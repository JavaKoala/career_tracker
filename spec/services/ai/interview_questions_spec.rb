require 'rails_helper'

RSpec.describe Ai::InterviewQuestions do
  let(:interview) { create(:interview) }

  describe '#create_interview_questions' do
    context 'when the interview is present' do
      let(:response) do
        "Here's a list of questions I'd ask:\n\n1. Can you tell me more?\n\n2. What are the biggest challenges?\n\n"
      end
      let(:service) { instance_double(OpenAI::Client, completions: { 'choices' => [{ 'text' => response }] }) }

      before do
        allow(OpenAI::Client).to receive(:new).and_return(service)
      end

      it 'creates interview questions' do
        intervice_service = described_class.new(interview.id, '0.5')

        expect do
          intervice_service.create_interview_questions
        end.to change(InterviewQuestion, :count).by(2)
      end

      it 'strips interview question' do
        intervice_service = described_class.new(interview.id, '0.5')
        intervice_service.create_interview_questions

        expect(interview.reload.interview_questions.first.question).to eq('Can you tell me more?')
      end

      it 'sets ai_generated to true' do
        intervice_service = described_class.new(interview.id, '0.5')
        intervice_service.create_interview_questions

        expect(interview.reload.interview_questions.first.ai_generated).to be true
      end
    end

    context 'when the interview is not present' do
      it 'does not create interview questions' do
        intervice_service = described_class.new(0, '0.5')

        expect do
          intervice_service.create_interview_questions
        end.not_to change(InterviewQuestion, :count)
      end
    end

    context 'when the llm is not enabled' do
      before do
        allow(Rails.configuration.openai).to receive(:[]).with(:enabled).and_return(false)
        allow(Rails.configuration.openai).to receive(:[]).with(:url).and_return('http://localhost:11434')
        allow(Rails.configuration.openai).to receive(:[]).with(:model).and_return('llama3.2:1b')
      end

      it 'does not create interview questions' do
        intervice_service = described_class.new(interview.id, '0.5')

        expect do
          intervice_service.create_interview_questions
        end.not_to change(InterviewQuestion, :count)
      end
    end
  end

  describe '#interview_questions_prompt' do
    it 'returns the interview questions prompt' do
      service = described_class.new(interview.id, '0.5')
      prompt = service.interview_questions_prompt

      expect(prompt).to match('^You are applying for a Software Engineer position at Company Name.')
    end

    it 'returns a default prompt when the interview is not present' do
      service = described_class.new(nil, '0.5')
      prompt = service.interview_questions_prompt

      expect(prompt).to match('You are applying for a  position at .')
    end
  end
end
