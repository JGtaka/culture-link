require "rails_helper"

RSpec.describe "Profiles", type: :request do
  describe "GET /profile" do
    context "ログイン済みの場合" do
      let(:user) { create(:user, name: "テスト太郎") }

      before do
        sign_in user
      end

      it "プロフィールページが表示される" do
        get profile_path
        expect(response).to have_http_status(:ok)
      end

      it "ユーザー名が表示される" do
        get profile_path
        expect(response.body).to include("テスト太郎")
      end

      it "ウェルカムメッセージが表示される" do
        get profile_path
        expect(response.body).to include("おかえりなさい")
      end

      describe "学習履歴カード" do
        context "受験済みのクイズがある場合" do
          let!(:completed_quiz) { create(:quiz, title: "ルネサンスのクイズ") }
          let!(:in_progress_quiz) { create(:quiz, title: "進行中クイズ") }
          let!(:other_user_quiz) { create(:quiz, title: "他人のクイズ") }

          before do
            create(:quiz_result, user: user, quiz: completed_quiz, status: :completed, score: 75)
            create(:quiz_result, user: user, quiz: in_progress_quiz, status: :in_progress, score: 0)
            create(:quiz_result, user: create(:user), quiz: other_user_quiz, status: :completed, score: 90)
          end

          it "受験済み(completed)のクイズが学習履歴に表示される" do
            get profile_path
            expect(response.body).to include("ルネサンスのクイズ")
          end

          it "受験中(in_progress)のクイズは学習履歴に表示されない" do
            get profile_path
            expect(response.body).not_to include("進行中クイズ")
          end

          it "他ユーザーのクイズ結果は表示されない" do
            get profile_path
            expect(response.body).not_to include("他人のクイズ")
          end

          it "スコアが表示される" do
            get profile_path
            expect(response.body).to include("75%")
          end
        end

        context "受験済みのクイズがない場合" do
          it "空状態メッセージが表示される" do
            get profile_path
            expect(response.body).to include("まだ受験済みのクイズがありません")
          end
        end

        context "受験済みクイズの並び順" do
          let!(:old_quiz) { create(:quiz, title: "古いクイズ") }
          let!(:new_quiz) { create(:quiz, title: "新しいクイズ") }

          before do
            create(:quiz_result, user: user, quiz: old_quiz, status: :completed, score: 50, updated_at: 2.days.ago)
            create(:quiz_result, user: user, quiz: new_quiz, status: :completed, score: 80, updated_at: 1.hour.ago)
          end

          it "最近受験した順に表示される" do
            get profile_path
            new_pos = response.body.index("新しいクイズ")
            old_pos = response.body.index("古いクイズ")
            expect(new_pos).to be < old_pos
          end
        end
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
