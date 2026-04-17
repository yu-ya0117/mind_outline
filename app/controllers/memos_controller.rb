# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: %i[show edit update destroy save_child ai_tools ai_generate]
  before_action :set_tree_root, only: %i[show edit ai_tools ai_generate]

  def index
    @memos = current_user.memos.roots.order(created_at: :desc)
  end

  def new
    @memo = current_user.memos.new
  end

  def create
    @memo = MemoCreator.new(
      user: current_user,
      memo_params: memo_params,
      tag_names: params[:tag_names]
    ).call

    redirect_to memos_path, notice: 'メモを作成しました。'
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = 'メモの作成に失敗しました。'
    render :new, status: :unprocessable_entity
  end

  def show = @children = @memo.children

  def edit
    @child_memo = current_user.memos.new
  end

  def update
    if @memo.update(memo_params)
      redirect_to memo_path(@memo), notice: 'メモを更新しました。'
    else
      @tree_root = @memo.root
      @child_memo = current_user.memos.new
      flash.now[:alert] = 'メモの更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memo.destroy!
    redirect_to memos_path, notice: 'メモを削除しました。'
  end

  def save_child
    @child_memo = current_user.memos.new(memo_params)
    @child_memo.parent = @memo

    if @child_memo.save
      redirect_to edit_memo_path(@memo), notice: '子メモを追加しました。'
    else
      @tree_root = @memo.root
      flash.now[:alert] = '子メモの追加に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

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

  def set_tree_root
    @tree_root = @memo.root
  end

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:title, :content)
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
