# frozen_string_literal: true

class GeneratedTextsController < ApplicationController
  before_action :authenticate_user!

  def create
    @memo = Memo.find(params[:memo_id])
    generated_text = @memo.generated_texts.build(generated_text_params)

    if generated_text.save
      redirect_to memo_path(@memo), notice: '生成結果を保存しました'
    else
      redirect_to memo_path(@memo), alert: '生成結果の保存に失敗しました'
    end
  end

  private

  def generated_text_params
    params.require(:generated_text).permit(:kind, :content)
  end
end
