# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'homes#index'

  resources :generated_texts, only: %i[index]
  resources :memos do
    member do
      post :save_child
      get  :ai_tools
      post :ai_generate
    end
    resources :generated_texts, only: %i[index create show]
  end
end
