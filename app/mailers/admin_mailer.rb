class AdminMailer < ApplicationMailer
  # LINE Push通知の送信に失敗したことを管理者へ知らせる
  def line_push_failed(user:, reason:)
    @user = user
    @reason = reason
    mail(
      to: ENV.fetch("ADMIN_NOTIFICATION_EMAIL"),
      subject: "【culture-link】LINE通知の送信に失敗しました"
    )
  end
end
