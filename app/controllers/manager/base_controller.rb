module Manager
  class BaseController < ApplicationController
    layout "manager"

    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to new_user_session_path unless current_user&.admin?
    end
  end
end
