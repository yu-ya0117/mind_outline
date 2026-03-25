# frozen_string_literal: true

require 'openai'

class AiTextService
  TAB_PROMPTS = {
    'organize' => <<~PROMPT,
      あなたは文章整理が得意なアシスタントです。
      入力されたメモを、必ず3階層以内のアウトライン形式で整理してください。

      ルール
      ・1行につき1項目
      ・インデントで階層を表す
      ・階層は最大3階層まで
      ・4階層以上は作らない
      ・箇条書き記号は「-」を使う
    PROMPT
    'summarize' => <<~PROMPT,
      あなたは文章要約が得意なアシスタントです。
      入力された内容を、要点がわかるように簡潔に要約してください。
    PROMPT
    'generate' => <<~PROMPT
      あなたは文章作成が得意なアシスタントです。
      入力されたメモをもとに、自然で読みやすい文章を作成してください。
    PROMPT
  }.freeze

  def self.generate(tab:, source_text:, user_prompt:, client: nil)
    new(
      tab: tab,
      source_text: source_text,
      user_prompt: user_prompt,
      client: client
    ).generate
  rescue StandardError => e
    "AI生成中にエラーが発生しました: #{e.message}"
  end

  def initialize(tab:, source_text:, user_prompt:, client: nil)
    @tab = tab
    @source_text = source_text.to_s
    @user_prompt = user_prompt.to_s
    @client = client || OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def generate
    response = @client.responses.create(
      model: :"gpt-4.1-mini",
      input: build_input
    )

    response.output_text
  end

  private

  attr_reader :tab, :source_text, :user_prompt

  def build_input
    <<~INPUT
      #{system_prompt}

      【元のメモ】
      #{source_text}

      【追加指示】
      #{user_prompt}
    INPUT
  end

  def system_prompt
    TAB_PROMPTS.fetch(tab, 'あなたは優秀なアシスタントです。')
  end
end
