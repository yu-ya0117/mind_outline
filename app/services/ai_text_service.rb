# frozen_string_literal: true

require 'openai'

class AiTextService
  def generate(tab:, content:, format: nil, tone: nil)
    prompt_builder = AiPromptBuilder.new(
      tab: tab,
      content: content,
      format: format,
      tone: tone
    )

    response = request_chat_completion(prompt_builder)
    clean_result(extract_content(response))
  rescue StandardError => e
    handle_error(e)
  end

  private

  def request_chat_completion(prompt_builder)
    client.chat.completions.create(
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: prompt_builder.system_prompt },
        { role: 'user', content: prompt_builder.user_prompt }
      ]
    )
  end

  def extract_content(response)
    response.choices[0].message.content
  end

  def clean_result(text)
    text.gsub(/\A```[a-zA-Z]*\n?/, "").gsub(/```\z/, "").strip
  end

  def handle_error(error)
    Rails.logger.error("AI generation failed: #{error.message}")
    'エラーメッセージ'
  end

  def client
    raise 'OPENAI_API_KEY is missing' if ENV['OPENAI_API_KEY'].blank?

    OpenAI::Client.new(api_key: ENV.fetch('OPENAI_API_KEY'))
  end
end
