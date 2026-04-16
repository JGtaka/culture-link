class ScheduleNotifier
  def initialize(schedule)
    @schedule = schedule
  end

  def notify_registered
    ScheduleMailer.registered(@schedule).deliver_later
  end
end
