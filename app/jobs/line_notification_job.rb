class LineNotificationJob < ApplicationJob
  queue_as :default

  # スケジュールが削除済みなら通知不要なので捨てる
  discard_on ActiveJob::DeserializationError

  # ネットワーク一時障害などに備えてデフォルト5回までリトライ
  # (LineNotifier側で永続エラーは内部処理しているので主にDB/HTTP一時エラー用)
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform(notification_type, schedule_id)
    schedule = Schedule.find_by(id: schedule_id)
    return unless schedule

    case notification_type.to_sym
    when :schedule_registered
      LineNotifier.new(schedule.user).schedule_registered(schedule)
    end
  end
end
