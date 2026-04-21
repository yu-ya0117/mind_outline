# frozen_string_literal: true

class AiWritingPromptBuilder
  def initialize(content:, format: nil, tone: nil)
    @content = content
    @format = format
    @tone = tone
  end

  def build
    <<~PROMPT
      次の内容をもとに、#{format_instruction}として使える自然な文章を作成してください。
      #{tone_instruction}
      #{writing_rule}
      #{structure_instruction}

      【内容】
      #{content}
    PROMPT
  end

  private

  attr_reader :content, :format, :tone

  def format_instruction
    case format
    when 'daily_report'
      '日報'
    when 'consultation'
      '相談文'
    when 'report'
      '報告文'
    else
      '文章'
    end
  end

  def tone_instruction
    case tone
    when 'casual'
      <<~TONE
        文体はややカジュアルにしてください。
        - 丁寧語（〜です・〜ます）は使用してもよいが、堅すぎる表現は避ける
        - 「いたしました」「〜でございます」などの強い敬語は使わない
        - 自然で話し言葉に近い表現を意識する
        - 一文を短めにして読みやすくする
        - 主語を「私は」など省略して自然な文章にする
        - 読み手に親しみやすい表現にする
      TONE
    else
      <<~TONE
        文体は丁寧にしてください。
        - ビジネス文として適切な敬語を使用する
        - 「〜いたしました」「〜でございます」などの丁寧な表現を使う
        - 客観的で落ち着いた文章にする
      TONE
    end
  end

  def writing_rule
    <<~RULE
      入力内容の意図を保ちながら、読みやすく簡潔にまとめてください。
      内容を勝手に増やしすぎず、不足部分の補完は最小限にしてください。
      コードブロック（```）は使わず、結果本文だけを出力してください。
    RULE
  end

  def structure_instruction
    case format
    when 'daily_report'
      daily_report_structure
    else
      default_structure
    end
  end

  def daily_report_structure
    <<~STRUCTURE
      以下の構成で出力してください。

      【本日の作業】
      - 今日行った作業内容

      【課題・気づき】
      - 課題や気づいたこと

      【明日の予定】
      - 次に行う予定の内容

      各見出しは必ず付けてください。
      内容が少ない場合でも、できるだけ上記3項目に整理してください。
    STRUCTURE
  end

  def default_structure
    '入力内容に応じて、自然で読みやすい構成に整えてください。'
  end
end
