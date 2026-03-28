class GeneratedTextsController < ApplicationController
  before_action :authenticate_user!

  def create
    @memo = Memo.find(params[:memo_id])
    GeneratedText.create!(
      memo: @memo,
      kind: params[:kind],
      content: params[:content]
    )

    redirect_to memo_path(@memo), notice: "保存しました"
  end
end
