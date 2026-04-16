class Account::PasswordsController < ApplicationController
  before_action :authenticate_user!

  def update
    unless current_user.password_changeable?
      redirect_to account_path, alert: "このアカウントではパスワードを変更できません"
      return
    end

    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      redirect_to account_path, notice: "パスワードを変更しました"
    else
      render "accounts/show", status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
