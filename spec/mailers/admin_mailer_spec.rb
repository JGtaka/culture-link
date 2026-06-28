require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "#line_push_failed" do
    let(:user) { create(:user, :line_user, name: "テスト太郎", email: "taro@example.com") }
    let(:reason) { "LINE Push APIが status=403 を返しました（恒久エラー）" }

    subject(:mail) { described_class.line_push_failed(user: user, reason: reason) }

    let(:text_body) { mail.text_part.body.to_s }
    let(:html_body) { mail.html_part.body.to_s }

    it "宛先がADMIN_NOTIFICATION_EMAILで設定したアドレスになる" do
      expect(mail.to).to eq([ ENV.fetch("ADMIN_NOTIFICATION_EMAIL") ])
    end

    it "ADMIN_NOTIFICATION_EMAILを変更するとその宛先に送る" do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ADMIN_NOTIFICATION_EMAIL").and_return("ops@example.com")
      expect(mail.to).to eq([ "ops@example.com" ])
    end

    it "送信元がデフォルトのFromに設定される" do
      expect(mail.from).to eq([ "noreply@mail.culturelink.jp" ])
    end

    it "件名がLINE通知失敗を示す" do
      expect(mail.subject).to eq("【culture-link】LINE通知の送信に失敗しました")
    end

    it "本文に失敗理由と対象ユーザー情報が含まれる" do
      expect(text_body).to include(reason)
      expect(text_body).to include("taro@example.com")
      expect(text_body).to include(user.uid)
      expect(html_body).to include(reason)
    end
  end
end
