require "rails_helper"

RSpec.describe ScheduleNotifier do
  describe "#notify_registered" do
    let(:schedule) { create(:schedule, user: user) }
    subject(:notifier) { described_class.new(schedule) }

    context "通常ユーザー(LINE未連携)の場合" do
      let(:user) { create(:user, email: "taro@example.com") }

      it "メールをdeliver_laterで送信する" do
        expect {
          notifier.notify_registered
        }.to have_enqueued_mail(ScheduleMailer, :registered).with(schedule)
      end

      it "LINE通知ジョブはエンキューされない" do
        expect {
          notifier.notify_registered
        }.not_to have_enqueued_job(LineNotificationJob)
      end
    end

    context "LINE連携ユーザーの場合" do
      let(:user) { create(:user, :line_user) }

      it "LineNotificationJob.perform_laterをエンキューする" do
        expect {
          notifier.notify_registered
        }.to have_enqueued_job(LineNotificationJob).with(:schedule_registered, schedule.id)
      end

      it "メールはdeliver_laterされない" do
        expect {
          notifier.notify_registered
        }.not_to have_enqueued_mail(ScheduleMailer, :registered)
      end
    end
  end
end
