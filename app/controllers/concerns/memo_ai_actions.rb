# frozen_string_literal: true

module MemoAiActions
  extend ActiveSupport::Concern

  def ai_tools
    @tab = params[:tab].presence || 'organize'
  end

  def ai_generate
    @tab = params[:tab].presence || 'organize'
    @result = AiTextService.new.generate(**ai_generate_params)
    log_ai_generate_params

    if @result.present?
      flash.now[:notice] = ai_success_message(@tab)
    else
      flash.now[:alert] = 'AI処理に失敗しました。時間をおいて再度お試しください。'
    end

    render :ai_tools
  end

  private

  def log_ai_generate_params
    Rails.logger.debug(
      "tab: #{params[:tab].inspect}, " \
      "format_type: #{params[:format_type].inspect}, " \
      "tone: #{params[:tone].inspect}, " \
      "result: #{@result.inspect}"
    )
  end

  def ai_generate_params
    {
      tab: @tab,
      content: ai_source_text_for_tab,
      format: params[:format_type],
      tone: params[:tone]
    }
  end

  def ai_source_text_for_tab
    @tab == 'organize' ? @memo.ai_tree_source_text : @memo.ai_source_text
  end

  def ai_success_message(tab)
    {
      'organize' => 'アウトラインを生成しました。',
      'summary' => '要約を生成しました。',
      'writing' => '文章を生成しました。'
    }.fetch(tab, 'AI処理が完了しました。')
  end
end
