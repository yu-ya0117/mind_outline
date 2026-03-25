# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'homes#index'

  resources :memos do
    member do
      post :save_child
      get  :ai_tools
      post :ai_generate
    end
  end
end
