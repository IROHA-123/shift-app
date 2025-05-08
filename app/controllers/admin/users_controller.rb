
# 管理者 admin が、従業員 user を登録する場所 --------------------------------------------

class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.where(role: "staff")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(role: "staff", password: "defaultpass"))
    if @user.save
      redirect_to admin_users_path, notice: "従業員を登録しました"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
