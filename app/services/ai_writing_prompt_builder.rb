# frozen_string_literal: true

class AiWritingPromptBuilder
  def initialize(content:, format: nil, tone: nil)
    @content = content
    @format = format
    @tone = tone
  end

  def build
    <<~PROMPT
      次のメモをもとに「#{format || '文章'}」を作成してください。

      文体は「#{tone || '丁寧'}」にしてください。
      #{tone_guide}

      用途ごとのルールは次の通りです。
      #{writing_format_rule}

      #{plain_output_rule}

      【メモ内容】
      #{content}
    PROMPT
  end

  private

  attr_reader :content, :format, :tone

  def tone_guide
    <<~TEXT
      - 「丁寧」の場合は、です・ます調で落ち着いた表現にしてください。
      - 「ややカジュアル」の場合は、柔らかく親しみやすい表現にしてください。ただし砕けすぎないでください。
    TEXT
  end

  def writing_format_rule
    case format
    when '日報'
      daily_report_rule
    when '相談文'
      consultation_rule
    when '報告文'
      report_rule
    else
      default_writing_rule
    end
  end

  def daily_report_rule
    <<~TEXT
      - 日報として作成してください。
      - 今日取り組んだこと、学んだこと、気づいたことを簡潔にまとめてください。
      - 読者への質問、相談、意見募集は含めないでください。
      - 事実と所感を自然につなげ、1〜2段落程度でまとめてください。
    TEXT
  end

  def consultation_rule
    <<~TEXT
      - 相談文として作成してください。
      - 自分の状況や考えを説明したうえで、相手に意見や助言を求める文章にしてください。
      - 相談したい点を明確にし、最後は相談・質問で締めてください。
      - 単なる報告文や日報にならないようにしてください。
    TEXT
  end

  def report_rule
    <<~TEXT
      - 報告文として作成してください。
      - 取り組んだ内容、状況、結果を整理して伝える文章にしてください。
      - 主観よりも事実の共有を優先してください。
      - 読者への質問や相談は含めないでください。
    TEXT
  end

  def default_writing_rule
    <<~TEXT
      - 自然で読みやすい文章にしてください。
      - 与えられたメモの内容を整理し、分かりやすく構成してください。
    TEXT
  end

  def plain_output_rule
    'コードブロック（```）、見出し記号、番号、箇条書きの記号、余計な前置きや説明文は付けず、結果本文だけを出力してください。'
  end
end
