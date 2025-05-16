class Manager::UsersController < ApplicationController
  layout "manager"
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(
      role: "staff",
      password: SecureRandom.hex(10),
      password_confirmation: SecureRandom.hex(10)
    ))

    if @user.save
      @user.send_reset_password_instructions
      redirect_to manager_users_path, notice: "従業員を登録し、パスワード設定用メールを送りました"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :employee_id, :joined_on, :work_style, :skill_level)
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
