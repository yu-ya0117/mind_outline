# frozen_string_literal: true

require 'openai'

class AiTextService
  SYSTEM_PROMPTS = {
    'organize' => 'あなたは思考整理が得意なアシスタントです。メモツリーの既存構造を尊重しながら、分かりやすい階層構造に整理してください。内容を勝手に増やしすぎず、構造化を優先してください。',
    'summary' => 'あなたは要点整理が得意なアシスタントです。簡潔で重複のない要約を作成してください。',
    'writing' => 'あなたは業務文章の作成が得意なアシスタントです。自然で読みやすい文章を作成してください。'
  }.freeze

  def generate(tab:, content:, format: nil, tone: nil)
    response = request_chat_completion(tab:, content:, format:, tone:)
    clean_result(extract_content(response))
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

  def clean_result(text)
    text.to_s
        .gsub(/\A```[\w-]*\n?/, '')
        .gsub(/\n?```\z/, '')
        .strip
  end

  def plain_output_rule
    'コードブロック（```）、見出し記号、番号、箇条書きの記号、余計な前置きや説明文は付けず、結果本文だけを出力してください。'
  end

  def handle_error(error)
    Rails.logger.error "OpenAI API Error: #{error.message}"
    'エラーメッセージ'
  end

  def client
    raise 'OPENAI_API_KEY is missing' if ENV['OPENAI_API_KEY'].blank?

    OpenAI::Client.new(api_key: ENV.fetch('OPENAI_API_KEY'))
  end

  def build_prompt(tab:, content:, format:, tone:)
    prompt_builders.fetch(tab).call(content, format, tone)
  end

  def prompt_builders
    {
      'organize' => ->(content, _format, _tone) { organize_prompt(content) },
      'summary' => ->(content, _format, _tone) { summary_prompt(content) },
      'writing' => ->(content, format, tone) { writing_prompt(content, format, tone) }
    }
  end

  def organize_prompt(content)
    <<~PROMPT
      次のメモツリーを、既存の内容と階層関係を踏まえて分かりやすく整理してください。
      タイトルのみで内容欄がないノードも、意味のある要素として扱ってください。
      既にある内容はなるべく活かし、重複やまとまりの悪さを整えることを優先してください。
      内容が不足している場合のみ、元のテーマから逸れない範囲でごく軽く補足してください。
      出力はインデントで階層を表現し、1行に1項目で記述してください。
      階層は最大3段程度までにしてください。
      #{plain_output_rule}

      【メモツリー】
      #{content}
    PROMPT
  end

  def summary_prompt(content)
    <<~PROMPT
      次のメモ内容を簡潔に要約してください。
      重要な内容を優先して、短く分かりやすくまとめてください。
      出力は自然な日本語で記述してください。
      #{plain_output_rule}

      【メモ内容】
      #{content}
    PROMPT
  end

  def writing_prompt(content, format, tone)
    <<~PROMPT
      次のメモをもとに#{format || '文章'}を作成してください。
      文体は#{tone || '丁寧'}で、自然で読みやすい日本語にしてください。
      内容はメモに沿って構成し、必要に応じて自然な接続を補ってください。
      #{plain_output_rule}

      【メモ内容】
      #{content}
    PROMPT
  end

  def system_prompt(tab)
    SYSTEM_PROMPTS.fetch(tab)
  end
end
