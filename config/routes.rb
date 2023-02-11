Rails.application.routes.draw do
  namespace :public do
    get 'posts/index'
    get 'posts/show'
    get 'posts/new'
    get 'posts/create'
    get 'posts/edit'
    get 'posts/ranking'
    get 'posts/search'
  end
  #Devise関連のルーティング
  ##管理者用
  devise_for :admin,skip:[:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
  }
  ##ユーザー用
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
# ユーザー側のルーティング設定
scope module: :public do
  root to: 'homes#top'
  resources :posts
  resources :users, only:[:show, :edit]

end

#管理者側のルーティング設定
namespace :admin do
  root to: "homes#top"
  resources :posts, only:[:show, :destroy]
  resources :users, only:[:show, :edit]
end

end
