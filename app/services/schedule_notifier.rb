class ScheduleNotifier
  def initialize(schedule)
    @schedule = schedule
    @user = schedule.user
  end

  def notify_registered
    if @user.line_provider?
      LineNotificationJob.perform_later(:schedule_registered, @schedule.id)
    else
      ScheduleMailer.registered(@schedule).deliver_later
    end
  end
end
