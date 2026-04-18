# frozen_string_literal: true

class MemosController < ApplicationController
  include MemoAiActions

  before_action :authenticate_user!
  before_action :set_memo, only: %i[show edit update destroy save_child ai_tools ai_generate]
  before_action :set_tree_root, only: %i[show edit ai_tools ai_generate]

  def index
    @memos = current_user.memos.roots.order(created_at: :desc)
    return if params[:tag].blank?

    @memos = @memos.joins(:tags).where(tags: { name: params[:tag] }).distinct
  end

  def new = @memo = current_user.memos.new

  def create
    creator = build_memo_creator
    @memo = creator.call

    redirect_to memos_path, notice: 'メモを作成しました。'
  rescue ActiveRecord::RecordInvalid
    @memo = creator.memo
    flash.now[:alert] = 'メモの作成に失敗しました。'
    render :new, status: :unprocessable_entity
  end

  def show = @children = @memo.children

  def edit = @child_memo = current_user.memos.new

  def update
    memo_updater.call
    redirect_to memo_path(@memo), notice: 'メモを更新しました。'
  rescue ActiveRecord::RecordInvalid
    @tree_root = @memo.root
    @child_memo = current_user.memos.new
    flash.now[:alert] = 'メモの更新に失敗しました。'
    render :edit, status: :unprocessable_entity
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

  private

  def set_tree_root = @tree_root = @memo.root

  def set_memo = @memo = current_user.memos.find(params[:id])

  def memo_params = params.require(:memo).permit(:title, :content)

  def build_memo_creator
    MemoCreator.new(
      user: current_user,
      memo_params: memo_params,
      tag_names: params[:tag_names]
    )
  end

  def memo_updater
    MemoUpdater.new(
      memo: @memo,
      memo_params: memo_params,
      tag_names: params[:tag_names],
      user: current_user
    )
  end
end
