module Ai
  class InterviewQuestions < LlmService
    def initialize(interview_id, temperature)
      @interview = Interview.find_by(id: interview_id)
      super(temperature)
    end

    def create_interview_questions
      return if @interview.blank? || !Rails.application.config.openai[:enabled]

      interview_questions = llm_completions(interview_questions_prompt)
      interview_questions = extract_interview_questions(interview_questions)

      interview_questions.each do |question|
        InterviewQuestion.create!(question: question, interview: @interview, ai_generated: true)
      end
    end

    def interview_questions_prompt
      <<~PROMPT
        You are applying for a #{@interview&.job_application&.position_name} position at #{@interview&.job_application&.company_name}.
        The job description is as follows: #{@interview&.job_application&.position_description}.
        Please write a list of five questions that you would ask about the position from the perspective of the applicant.
      PROMPT
    end

    private

    def extract_interview_questions(interview_questions)
      interview_questions.split(/\n\d+\./).drop(1).map(&:strip)
    end
  end
end
