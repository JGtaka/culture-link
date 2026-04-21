class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :enforce_suspension

  private

  # 停止中ユーザーの既存セッションを無効化する
  def enforce_suspension
    return unless user_signed_in? && current_user.suspended?

    sign_out current_user
    redirect_to new_user_session_path, alert: "このアカウントは停止されています。管理者にお問い合わせください。"
  end

  def after_sign_in_path_for(resource)
    profile_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
