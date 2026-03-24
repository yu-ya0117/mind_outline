# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: %i[show edit update destroy save_child]

  def index
    @memos = current_user.memos.roots.order(created_at: :desc)
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

  def show
    @children = @memo.children
  end

  def edit
    @child_memo = current_user.memos.new
  end

  def update
    if @memo.update(memo_params)
      redirect_to memo_path(@memo), notice: 'メモを更新しました。'
    else
      @child_memo = current_user.memos.new
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
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:title, :content)
  end
end
