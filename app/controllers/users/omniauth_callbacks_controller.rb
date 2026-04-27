class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url,
                  alert: "Googleログインに失敗しました。メールアドレスが既に登録済みか、Google側でメール認証が完了していない可能性があります。"
    end
  end

  def line
    auth = request.env["omniauth.auth"]

    # メアドが取れていなければ補完画面へ
    if auth.info.email.blank?
      session["devise.line_data"] = auth.except("extra").to_hash
      redirect_to line_email_setup_path and return
    end

    user = User.from_omniauth(auth)

    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
    else
      session["devise.line_data"] = auth.except("extra").to_hash
      redirect_to new_user_registration_url,
                  alert: "LINEログインに失敗しました。同じメールアドレスのアカウントが既に登録されている可能性があります。"
    end
  end

  # LINEからメアドを取得できなかった場合に表示する補完フォーム
  def line_email_setup
    @auth_data = session["devise.line_data"]
    if @auth_data.blank?
      redirect_to new_user_session_path,
                  alert: "セッションが無効です。再度LINEログインからお試しください。" and return
    end
  end

  # 補完フォームの送信処理
  def line_complete
    auth_data = session["devise.line_data"]
    if auth_data.blank?
      redirect_to new_user_session_path,
                  alert: "セッションが無効です。再度LINEログインからお試しください。" and return
    end

    auth = OmniAuth::AuthHash.new(auth_data)
    email = params.dig(:user, :email).to_s.strip

    user = User.create_from_omniauth_with_email(auth, email)

    if user&.persisted?
      session.delete("devise.line_data")
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
    else
      @auth_data = auth_data
      flash.now[:alert] = "メールアドレスが既に登録されているか、入力内容が無効です。"
      render :line_email_setup, status: :unprocessable_content
    end
  end

  def failure
    redirect_to new_user_session_path, alert: "認証に失敗しました。もう一度お試しください。"
  end
end
