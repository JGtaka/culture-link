require "rails_helper"

RSpec.describe LineNotifier do
  let(:user) { create(:user, :line_user) }
  let(:schedule) do
    create(:schedule,
      user: user,
      start_date: Date.new(2026, 4, 27),
      end_date: Date.new(2026, 5, 10),
      daily_study_hours: 2,
      weekdays: [ 0, 2, 4 ],
      memo: "受験まで半年!")
  end
  let(:notifier) { described_class.new(user) }
  let(:push_url) { "https://api.line.me/v2/bot/message/push" }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("LINE_MESSAGING_CHANNEL_ACCESS_TOKEN").and_return("test-token")
    ActionMailer::Base.deliveries.clear
  end

  describe "#schedule_registered" do
    context "LINE連携ユーザーの場合" do
      it "LINE Push APIにテキストメッセージを送信する" do
        stub = stub_request(:post, push_url)
          .with(headers: { "Authorization" => "Bearer test-token" })
          .to_return(status: 200, body: '{"sentMessages":[]}', headers: { "Content-Type" => "application/json" })

        notifier.schedule_registered(schedule)
        expect(stub).to have_been_requested
      end

      it "送信先(to)がuserのuidになる" do
        stub_request(:post, push_url).to_return(status: 200, body: '{"sentMessages":[]}')

        notifier.schedule_registered(schedule)
        expect(WebMock).to have_requested(:post, push_url).with { |req|
          JSON.parse(req.body)["to"] == user.uid
        }
      end

      it "メッセージに学習期間/曜日/メモ/リンクが含まれる" do
        stub_request(:post, push_url).to_return(status: 200, body: '{"sentMessages":[]}')

        notifier.schedule_registered(schedule)
        expect(WebMock).to have_requested(:post, push_url).with { |req|
          text = JSON.parse(req.body).dig("messages", 0, "text").to_s
          text.include?("4月27日") &&
            text.include?("5月10日") &&
            text.include?("2時間") &&
            text.include?("月、水、金") &&
            text.include?("受験まで半年!") &&
            text.include?("http://www.example.com/profile")
        }
      end

      context "memoが空のとき" do
        let(:schedule) { create(:schedule, user: user, memo: nil) }

        it "メモ行を含めずに送信する" do
          stub_request(:post, push_url).to_return(status: 200, body: '{"sentMessages":[]}')

          notifier.schedule_registered(schedule)
          expect(WebMock).to have_requested(:post, push_url).with { |req|
            text = JSON.parse(req.body).dig("messages", 0, "text").to_s
            !text.include?("メモ")
          }
        end
      end

      context "API呼び出しが4xx(恒久エラー: Botブロック等)を返したとき" do
        before do
          stub_request(:post, push_url)
            .to_return(status: 403, body: '{"message":"You cannot push messages..."}')
        end

        it "例外を吐かず、リトライせず、管理者にメール通知する" do
          expect {
            notifier.schedule_registered(schedule)
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it "管理者メールの宛先(ADMIN_NOTIFICATION_EMAIL)と件名が正しい" do
          notifier.schedule_registered(schedule)
          mail = ActionMailer::Base.deliveries.last
          expect(mail.to).to eq([ ENV.fetch("ADMIN_NOTIFICATION_EMAIL") ])
          expect(mail.subject).to eq("【culture-link】LINE通知の送信に失敗しました")
        end
      end

      context "API呼び出しが5xx(一時エラー)を返したとき" do
        before do
          stub_request(:post, push_url).to_return(status: 500, body: '{"message":"server error"}')
        end

        it "TemporaryPushErrorを再raiseしてジョブにリトライさせる" do
          expect { notifier.schedule_registered(schedule) }
            .to raise_error(LineNotifier::TemporaryPushError)
        end

        it "この時点では管理者メールを送らない(リトライ枯渇後にジョブが送る)" do
          expect {
            begin
              notifier.schedule_registered(schedule)
            rescue LineNotifier::TemporaryPushError
              nil
            end
          }.not_to change { ActionMailer::Base.deliveries.size }
        end
      end

      context "ネットワーク例外が起きたとき" do
        before do
          stub_request(:post, push_url).to_raise(SocketError.new("name resolution error"))
        end

        it "一時障害とみなしTemporaryPushErrorとして再raiseする" do
          expect { notifier.schedule_registered(schedule) }
            .to raise_error(LineNotifier::TemporaryPushError, /SocketError/)
        end
      end
    end

    context "LINE未連携ユーザーの場合" do
      let(:user) { create(:user) }

      it "LINE APIを呼ばない" do
        notifier.schedule_registered(schedule)
        expect(WebMock).not_to have_requested(:post, push_url)
      end
    end
  end
end
