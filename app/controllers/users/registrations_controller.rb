class Users::RegistrationsController < Devise::RegistrationsController
  DELETION_CONFIRMATION_TEXT = "退会".freeze

  def destroy
    if resource.password_changeable?
      unless resource.valid_password?(params.dig(:user, :current_password).to_s)
        redirect_to account_path, alert: "現在のパスワードが正しくありません"
        return
      end
    else
      unless params.dig(:user, :deletion_confirmation) == DELETION_CONFIRMATION_TEXT
        redirect_to account_path, alert: "確認のため「#{DELETION_CONFIRMATION_TEXT}」と入力してください"
        return
      end
    end

    super
  end

  protected

  def update_resource(resource, params)
    params.delete(:current_password)
    resource.update(params)
  end

  def after_update_path_for(resource)
    profile_path
  end
end
