# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise関連のルーティング
  # #管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
  }

  # #ユーザー用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ユーザー側のルーティング設定
  scope module: :public do
    root to: "homes#top"
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      get "show_detail"
      resources :comments, only: [:create, :destroy]
      resources :favorites, only: [:create, :destroy]
      collection do
        get "search"
        get "map"
      end
    end
    resources :users, only: [:show, :edit, :update]
    get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  end

  # 管理者側のルーティング設定
  namespace :admin do
    root to: "homes#top"
    resources :posts, only: [:show, :destroy] do
      resources :comments, only: [:destroy]
    end
    resources :users, only: [:show, :index, :destroy]
    patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    resources :tags, only: [:index, :destroy]
  end
end
