# frozen_string_literal: true

class AiPromptBuilder
  SYSTEM_PROMPTS = {
    'organize' => 'あなたは思考整理が得意なアシスタントです。メモツリーの既存構造を尊重しながら、分かりやすい階層構造に整理してください。内容を勝手に増やしすぎず、構造化を優先してください。',
    'summary' => 'あなたは要点整理が得意なアシスタントです。簡潔で重複のない要約を作成してください。',
    'writing' => 'あなたは業務文章の作成が得意なアシスタントです。自然で読みやすい文章を作成してください。'
  }.freeze

  def initialize(tab:, content:, format: nil, tone: nil)
    @tab = tab
    @content = content
    @format = format
    @tone = tone
  end

  def system_prompt
    SYSTEM_PROMPTS.fetch(tab)
  end

  def user_prompt
    prompt_builders.fetch(tab).call
  end

  private

  attr_reader :tab, :content, :format, :tone

  def prompt_builders
    {
      'organize' => -> { organize_prompt },
      'summary' => -> { summary_prompt },
      'writing' => -> { writing_prompt }
    }
  end

  def organize_prompt
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

  def summary_prompt
    <<~PROMPT
      次のメモ内容を簡潔に要約してください。
      重要な内容を優先して、短く分かりやすくまとめてください。
      出力は自然な日本語で記述してください。
      #{plain_output_rule}

      【メモ内容】
      #{content}
    PROMPT
  end

  def writing_prompt
    AiWritingPromptBuilder.new(
      content: content,
      format: format,
      tone: tone
    ).build
  end

  def plain_output_rule
    'コードブロック（```）、見出し記号、番号、箇条書きの記号、余計な前置きや説明文は付けず、結果本文だけを出力してください。'
  end
end
