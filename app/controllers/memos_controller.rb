# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!

  def index
    @memos = current_user.memos.includes(:user).order(created_at: :desc)
  end

  def new
    @memo = current_user.memos.new
  end

  def create
    @memo = current_user.memos.new(memo_params)

    if @memo.save
      redirect_to memos_path, notice: 'メモを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def memo_params
    params.require(:memo).permit(:title, :content)
  end
end
