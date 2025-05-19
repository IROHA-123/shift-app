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
  # ──────────────────────────────────────
  # 1. 案件割当一覧 (Assignments#Index)
  #    - GET /manager/assignments
  #    - 一覧画面を表示するだけのルート
  # ──────────────────────────────────────
  resources :assignments, only: [:index] do
    # 「collection do … end」で定義するのは
    # /manager/assignments/:id ではなく
    # /manager/assignments/* のように
    # コレクション全体に対するルートです。
    collection do
      # PATCH /manager/assignments/update_members
      # ここにまとめてPOST (PATCH) して、配置メンバーを更新するアクションを作ります
      patch :update_members
    end
  end

  # ──────────────────────────────────────
  # 2. 確定シフト一覧＆更新 (ConfirmationsController)
  #    - パスだけ confirmed にマッピング
  #    - URL: /manager/confirmed
  # ──────────────────────────────────────
  resources :confirmations,
            path:       'confirmed',      # URLパスだけ "confirmed" に
            controller: 'confirmed',      # Manager::ConfirmedController を使う
            only:       [:index, :update] do
    collection do
      get :download   # /manager/confirmed/download
    end
  end

  # ──────────────────────────────────────
  # 3. その他 CRUD（ProjectsController & UsersController）
  #    Projects: index, new, create, update ＋
  #      - 個別割当画面 (assignment)
  #      - 完了処理        (complete_assignment)
  #    Users   : index, new, create, update
  # ──────────────────────────────────────
  resources :projects, only: [:index, :new, :create, :update] do
    member do
      # GET  /manager/projects/:id/assignment
      # → Manager::ProjectsController#assignment
      get   :assignment

      # PATCH /manager/projects/:id/complete_assignment
      # → Manager::ProjectsController#complete_assignment
      patch :complete_assignment
      # クリックで確定⇔希望を切り替える
      patch :toggle_request
    end
  end

  resources :users, only: [:index, :new, :create, :update]
end



end