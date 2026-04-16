require "rails_helper"

RSpec.describe ScheduleNotifier do
  describe "#notify_registered" do
    let(:user) { create(:user, email: "taro@example.com") }
    let(:schedule) { create(:schedule, user: user) }

    subject(:notifier) { described_class.new(schedule) }

    it "メールをdeliver_laterで送信する" do
      expect {
        notifier.notify_registered
      }.to have_enqueued_mail(ScheduleMailer, :registered).with(schedule)
    end
  end
end
