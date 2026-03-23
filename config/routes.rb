# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'homes#index'

  resources :memos do
    member do
      post :save_child
    end
  end
end
