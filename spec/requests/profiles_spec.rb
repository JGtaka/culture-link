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

      describe "最近チェックした項目" do
        context "閲覧履歴がある場合" do
          let!(:old_event) { create(:event, title: "古い出来事") }
          let!(:new_event) { create(:event, title: "新しい出来事") }
          let!(:character) { create(:character, name: "登場人物A") }

          before do
            create(:article_view, user: user, article: old_event, updated_at: 3.days.ago)
            create(:article_view, user: user, article: new_event, updated_at: 1.hour.ago)
            create(:article_view, user: user, article: character, updated_at: 1.day.ago)
          end

          it "閲覧したEventとCharacterが両方表示される" do
            get profile_path
            expect(response.body).to include("古い出来事")
            expect(response.body).to include("新しい出来事")
            expect(response.body).to include("登場人物A")
          end

          it "最新閲覧順(updated_at DESC)に並ぶ" do
            get profile_path
            new_pos = response.body.index("新しい出来事")
            char_pos = response.body.index("登場人物A")
            old_pos = response.body.index("古い出来事")
            expect(new_pos).to be < char_pos
            expect(char_pos).to be < old_pos
          end

          it "他ユーザーの閲覧履歴は表示されない" do
            other_user = create(:user)
            other_event = create(:event, title: "他人の出来事")
            create(:article_view, user: other_user, article: other_event)
            get profile_path
            expect(response.body).not_to include("他人の出来事")
          end

          it "最大4件まで表示される" do
            5.times do |i|
              event = create(:event, title: "イベント#{i}")
              create(:article_view, user: user, article: event, updated_at: (i + 10).hours.ago)
            end
            get profile_path
            # 最古の1件(3日前の「古い出来事")は4件制限で切られる想定
            expect(response.body).not_to include("古い出来事")
          end
        end

        context "閲覧履歴がない場合" do
          it "空状態メッセージが表示される" do
            get profile_path
            expect(response.body).to include("直近に確認した記事はありません")
          end
        end
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
