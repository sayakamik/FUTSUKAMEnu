Rails.application.routes.draw do

  namespace :public do
    get 'post_comments/index'
  end
  namespace :public do
    get 'favorites/index'
  end
  namespace :public do
    get 'recipes/new'
    get 'recipes/index'
    get 'recipes/show'
    get 'recipes/edit'
    get 'recipes/draft_index'
  end
  namespace :public do
    get 'users/mypage'
    get 'users/show'
    get 'users/edit'
    get 'users/confirm_withdraw'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users, skip: [:passwords] , controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] , controllers: {
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
