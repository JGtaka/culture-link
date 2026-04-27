require "rails_helper"

RSpec.describe LineNotificationJob, type: :job do
  let(:user) { create(:user, :line_user) }
  let(:schedule) { create(:schedule, user: user) }

  describe "#perform" do
    it "notification_typeが :schedule_registered のときLineNotifier#schedule_registeredを呼ぶ" do
      notifier = instance_double(LineNotifier)
      allow(LineNotifier).to receive(:new).with(user).and_return(notifier)
      expect(notifier).to receive(:schedule_registered).with(schedule)

      described_class.perform_now(:schedule_registered, schedule.id)
    end

    it "schedule_idのレコードが削除されていたら何もせず終了する" do
      deleted_id = schedule.id
      schedule.destroy

      expect(LineNotifier).not_to receive(:new)
      expect { described_class.perform_now(:schedule_registered, deleted_id) }.not_to raise_error
    end

    it "perform_laterでデフォルトキューに登録される" do
      expect { described_class.perform_later(:schedule_registered, schedule.id) }
        .to have_enqueued_job(described_class).on_queue("default")
    end
  end
end
