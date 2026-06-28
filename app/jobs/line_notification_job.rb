class LineNotificationJob < ApplicationJob
  queue_as :default

  # スケジュールが削除済みなら通知不要なので捨てる
  discard_on ActiveJob::DeserializationError

  # LINE側の一時エラー(5xx/429/ネットワーク)は5回までリトライ。
  # 5回リトライしても回復しなければ管理者へメール通知する。
  # (恒久エラーはLineNotifier側で即通知済みなのでここには来ない)
  retry_on LineNotifier::TemporaryPushError, wait: :polynomially_longer, attempts: 5 do |job, error|
    _notification_type, schedule_id = job.arguments
    schedule = Schedule.find_by(id: schedule_id)
    next unless schedule

    AdminMailer.line_push_failed(
      user: schedule.user,
      reason: "LINE通知が一時エラーで5回リトライしても送信できませんでした（#{error.message}）"
    ).deliver_now
  end

  def perform(notification_type, schedule_id)
    schedule = Schedule.find_by(id: schedule_id)
    return unless schedule

    case notification_type.to_sym
    when :schedule_registered
      LineNotifier.new(schedule.user).schedule_registered(schedule)
    end
  end
end
