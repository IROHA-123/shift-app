Rails.application.routes.draw do

  # Deviseログイン
  devise_for :users

  # 認証済みユーザーの root
  authenticated :user do
    root to: "scheduler/shift_requests#index", as: :authenticated_root
  end

  # 未認証ユーザーの root
  unauthenticated do
    root to: "devise/sessions#new", as: :unauthenticated_root
  end

  # ------------------------------------------------------------------
  # 管理者画面
  namespace :admin do
    resources :users, only: [:index, :new, :create]
    resources :projects, only: [:index, :new, :create]
  end

  # 従業員画面
  namespace :scheduler do
    resources :shift_requests, only: [:index, :create] do
      collection do
        get :modal        # Ajax用のモーダル取得
        get :my_shifts    # 自分のシフト一覧
      end
    end
  end 

  # シフト調整画面（Shift Manager）
  namespace :manager do
    resources :shifts, only: [:index, :update]
  end
end
