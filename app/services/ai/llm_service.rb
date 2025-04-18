module Ai
  class LlmService
    def initialize(temperature)
      @temperature = temperature.to_f
      @client = OpenAI::Client.new(
        uri_base: Rails.application.config.openai[:url],
        request_timeout: Rails.application.config.openai[:timeout]
      )
    end

    def llm_completions(prompt)
      response = @client.completions(parameters: { model: Rails.application.config.openai[:model],
                                                   prompt: prompt,
                                                   max_tokens: Rails.application.config.openai[:max_tokens],
                                                   temperature: @temperature })

      response['choices']&.first&.dig('text')
    end
  end
end
