# frozen_string_literal: true

require 'openai'

class AiTextService
  SYSTEM_PROMPTS = {
    'organize' => 'あなたは思考整理が得意なアシスタントです。内容を勝手に増やさず、構造化を優先してください。',
    'summary' => 'あなたは要点整理が得意なアシスタントです。簡潔で重複のない要約を作成してください。',
    'writing' => 'あなたは業務文章の作成が得意なアシスタントです。自然で読みやすい文章を作成してください。'
  }.freeze

  def generate(tab:, content:, format: nil, tone: nil)
    response = request_chat_completion(tab:, content:, format:, tone:)
    extract_content(response)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def request_chat_completion(tab:, content:, format:, tone:)
    client.chat.completions.create(
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: system_prompt(tab) },
        { role: 'user', content: build_prompt(tab:, content:, format:, tone:) }
      ]
    )
  end

  def extract_content(response)
    response.choices[0].message.content
  end

  def handle_error(error)
    Rails.logger.error "OpenAI API Error: #{error.message}"
    'エラーメッセージ'
  end

  def client
    OpenAI::Client.new(
      api_key: ENV.fetch('OPENAI_API_KEY')
    )
  end

  def build_prompt(tab:, content:, format:, tone:)
    case tab
    when 'organize'
      organize_prompt(content)
    when 'summary'
      summary_prompt(content)
    when 'writing'
      writing_prompt(content, format, tone)
    else
      raise ArgumentError, "Unknown tab: #{tab}"
    end
  end

  def organize_prompt(content)
    <<~PROMPT
      次のメモを階層構造のアウトラインに整理してください。
      インデントで階層を表現し、1行に1項目で出力してください。

      【メモ】
      #{content}
    PROMPT
  end

  def summary_prompt(content)
    <<~PROMPT
      次のメモを簡潔に要約してください。
      箇条書きで3〜5点にまとめてください。

      【メモ】
      #{content}
    PROMPT
  end

  def writing_prompt(content, format, tone)
    <<~PROMPT
      次のメモをもとに#{format || '文章'}を作成してください。
      文体は#{tone || '丁寧'}でお願いします。

      【メモ】
      #{content}
    PROMPT
  end

  def system_prompt(tab)
    SYSTEM_PROMPTS.fetch(tab)
  end
end
