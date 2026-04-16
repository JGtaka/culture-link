require "rails_helper"

RSpec.describe ScheduleMailer, type: :mailer do
  describe "#registered" do
    let(:user) { create(:user, name: "テスト太郎", email: "taro@example.com") }
    let(:unit) { create(:study_unit, name: "飛鳥文化") }
    let(:schedule) do
      create(:schedule,
        user: user,
        start_date: Date.new(2026, 4, 20),
        end_date: Date.new(2026, 4, 27),
        daily_study_hours: 2,
        weekdays: [ 0, 2, 4 ],
        memo: "毎日コツコツ頑張る",
        study_units: [ unit ])
    end

    subject(:mail) { described_class.registered(schedule) }

    let(:text_body) { mail.text_part.body.to_s }
    let(:html_body) { mail.html_part.body.to_s }

    it "宛先がスケジュール作成ユーザーのメールアドレスになる" do
      expect(mail.to).to eq([ "taro@example.com" ])
    end

    it "送信元がデフォルトのFromに設定される" do
      expect(mail.from).to eq([ "noreply@mail.culturelink.jp" ])
    end

    it "件名が設定される" do
      expect(mail.subject).to eq("【culture-link】学習予定を登録しました")
    end

    it "テキスト本文とHTML本文にユーザー名が含まれる" do
      expect(text_body).to include("テスト太郎")
      expect(html_body).to include("テスト太郎")
    end

    it "本文に学習期間が含まれる" do
      expect(text_body).to include("2026")
      expect(text_body).to include("4")
      expect(text_body).to include("20")
    end

    it "本文に1日の目標学習時間が含まれる" do
      expect(text_body).to include("2時間")
    end

    it "本文に学習ユニットが含まれる" do
      expect(text_body).to include("飛鳥文化")
    end

    it "本文にメモが含まれる" do
      expect(text_body).to include("毎日コツコツ頑張る")
    end
  end
end
