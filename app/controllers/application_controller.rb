class ApplicationController < ActionController::Base
  # Devise でサインイン直後のリダイレクト先を切り替える
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_users_path    # 管理者は /admin/users へ
    else
      super               # それ以外はデフォルト（直前 or root_path）
    end
  end
end
