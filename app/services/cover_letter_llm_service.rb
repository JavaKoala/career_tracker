class CoverLetterLlmService
  def initialize(job_application_id)
    @job_application = JobApplication.find_by(id: job_application_id)
    @client = OpenAI::Client.new(uri_base: Rails.application.config.openai[:url])
  end

  def create_cover_letter
    return if @job_application.blank? || !Rails.application.config.openai[:enabled]

    cover_letter = llm_completions
    cover_letter_io = StringIO.new(cover_letter)

    @job_application.cover_letter.attach(io: cover_letter_io,
                                         filename: "ai_#{@job_application.company_name}_cover_letter.txt",
                                         content_type: 'text/plain')

    cover_letter_io.close
  end

  def cover_letter_prompt
    <<~PROMPT
      You are applying for a #{@job_application&.position_name} position at #{@job_application&.company_name}.
      The job description is as follows: #{@job_application&.position_description}.
      Please write a cover letter that explains why you are a good fit for this position.
    PROMPT
  end

  def llm_completions
    response = @client.completions(parameters: { model: Rails.application.config.openai[:model],
                                                 prompt: cover_letter_prompt, max_tokens: 1000 })
    response['choices']&.first&.dig('text')
  end
end
