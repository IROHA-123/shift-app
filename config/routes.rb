Rails.application.routes.draw do

  # Deviseログイン
  devise_for :users, skip: [:registrations]  # 新規登録を無効化
  
  # 認証済みユーザーの root
  authenticated :user do
    root to: "scheduler/shift_requests#index", as: :authenticated_root
  end

  # 未認証ユーザーの root
  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # ------------------------------------------------------------------

  # スタッフ画面（Shift Scheduler）
  namespace :scheduler do
    resources :shift_requests, only: [:index, :create] do
      collection do
        get :modal        # Ajax用のモーダル取得
        get :my_shifts
      end
    end
  end 

  # ------------------------------------------------------------------
  
  # 管理者画面（Shift Manager）
  namespace :manager do
    # 案件割当一覧
    resources :assignments,   only: [:index]

    # 確定シフト一覧＆更新（URL は /manager/confirmed/* のまま）
    resources :confirmations,
              path:       'confirmed',      # URL パスだけ “confirmed” に
              controller: 'confirmed',      # コントローラは Manager::ConfirmedController
              only:       [:index, :update] do
      collection do
        get :download
      end
    end
    
    # その他 CRUD
    resources :projects, only: [:index, :new, :create, :update] do
      member do
        get :assignment  # /manager/projects/:id/assignment にマッピング
        patch :complete_assignment
      end
    end
    resources :users,         only: [:index, :new, :create, :update]
  end


end