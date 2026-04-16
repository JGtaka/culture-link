class ScheduleMailer < ApplicationMailer
  rescue_from ActiveJob::DeserializationError do |error|
    Rails.logger.info("ScheduleMailer: skipped due to deleted record - #{error.message}")
  end

  def registered(schedule)
    @schedule = schedule
    @user = schedule.user
    @study_units = schedule.study_units.to_a
    mail(to: @user.email, subject: "【culture-link】学習予定を登録しました")
  end
end
