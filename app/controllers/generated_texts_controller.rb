# frozen_string_literal: true

class GeneratedTextsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [:create]

  def index
    if params[:memo_id].present?
      @memo = current_user.memos.find(params[:memo_id])
      @generated_texts = @memo.generated_texts.order(created_at: :desc)
    else
      @generated_texts = GeneratedText.for_user(current_user).order(created_at: :desc)
    end
  end

  def show
    @memo = current_user.memos.find(params[:memo_id])
    @generated_text = @memo.generated_texts.find(params[:id])
  end

  def create
    generated_text = @memo.generated_texts.build(generated_text_params)

    if generated_text.save
      redirect_to memo_path(@memo), notice: '生成結果を保存しました'
    else
      prepare_failed_create(generated_text)
      flash.now[:alert] = '生成結果の保存に失敗しました'
      render 'memos/ai_tools', status: :unprocessable_entity
    end
  end

  private

  def generated_text_params
    params.require(:generated_text).permit(:kind, :content)
  end

  def set_memo
    @memo = current_user.memos.find(params[:memo_id])
  end

  def prepare_failed_create(generated_text)
    @tree_root = @memo.root
    @tab = params[:tab].presence || 'organize'
    @result = generated_text.content
  end
end
