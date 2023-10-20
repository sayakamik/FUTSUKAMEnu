Rails.application.routes.draw do

  # 顧客用
  devise_for :users, skip: [:passwords] , controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] , controllers: {
    sessions: "admin/sessions"
  }

  #ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  #管理者
  namespace :admin do
    get '/' => "homes#top"
    resources :comments, only: [:index]
    resources :users, only: [:show, :edit, :update]
    resources :recipes, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy]
    end
  end

  #会員
  scope module: :public do
    #最初にコメント一覧はないが念の為
    get 'post_comments/index'
    resources :favorites, only: [:index]
    resources :original_menus, only: [:index]
    get 'recipes/draft_index' => 'recipes#draft_index'
    # タグの検索で使用する
    get "recipes/search_tag" => "recipes#search_tag"
    get "recipes/tag_index" => "recipes#tag_index"
    delete 'recipes/destroy_all' => 'recipes#destroy_all'
    resources :recipes, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end

    get 'mypage' => 'users#mypage'
    get 'users/information/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    get 'users/confirm_withdraw' => 'users#confirm_withdraw'
    patch 'users/withdraw' => 'users#withdraw'
    resources :users, only: [:show]
    root to: 'homes#top'
    get 'homes/about'

  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
