require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  let(:user) { create(:user) }

  describe "GET /quizzes" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get quizzes_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before { sign_in user }

      it "正常にレスポンスを返す" do
        get quizzes_path
        expect(response).to have_http_status(:ok)
      end

      it "ページタイトルが表示される" do
        get quizzes_path
        expect(response.body).to include("小テスト一覧")
      end

      context "一覧表示" do
        let!(:category) { create(:quiz_category, name: "ルネサンス") }
        let!(:quiz) { create(:quiz, :published, title: "ルネサンスの文化と芸術", quiz_category: category) }

        it "クイズのタイトルが表示される" do
          get quizzes_path
          expect(response.body).to include("ルネサンスの文化と芸術")
        end

        it "カテゴリ名が表示される" do
          get quizzes_path
          expect(response.body).to include("ルネサンス")
        end

        it "問題数が表示される" do
          create_list(:question, 3, quiz: quiz)
          get quizzes_path
          expect(response.body).to include("4問")
        end

        it "非公開クイズは一覧に表示されない" do
          create(:quiz, title: "非公開クイズ", quiz_category: category)
          get quizzes_path
          expect(response.body).not_to include("非公開クイズ")
        end
      end

      context "ページネーション" do
        before do
          create_list(:quiz, 8, :published)
        end

        it "1ページあたり最大6件" do
          get quizzes_path
          expect(response).to have_http_status(:ok)
        end

        it "2ページ目にアクセスできる" do
          get quizzes_path, params: { page: 2 }
          expect(response).to have_http_status(:ok)
        end

        it "ページネーションリンクが表示される" do
          get quizzes_path
          expect(response.body).to include("page=2")
        end
      end

      context "データが少ない場合" do
        before { create_list(:quiz, 3, :published) }

        it "ページネーションリンクが表示されない" do
          get quizzes_path
          expect(response.body).not_to include("page=2")
        end
      end

      context "カテゴリフィルター" do
        let!(:category_a) { create(:quiz_category, name: "ルネサンスA") }
        let!(:category_b) { create(:quiz_category, name: "バロックB") }
        let!(:quiz_a) { create(:quiz, :published, title: "クイズAAA", quiz_category: category_a) }
        let!(:quiz_b) { create(:quiz, :published, title: "クイズBBB", quiz_category: category_b) }

        it "カテゴリで絞り込みできる" do
          get quizzes_path, params: { quiz_category_id: category_a.id }
          expect(response.body).to include("クイズAAA")
          expect(response.body).not_to include("クイズBBB")
        end

        it "カテゴリ未指定なら全件表示される" do
          get quizzes_path
          expect(response.body).to include("クイズAAA")
          expect(response.body).to include("クイズBBB")
        end
      end

      context "状態別ボタン表示" do
        let!(:quiz_new) { create(:quiz, :published, title: "新規クイズ") }
        let!(:quiz_done) { create(:quiz, :published, title: "完了クイズ") }

        before do
          create(:quiz_result, user: user, quiz: quiz_done, status: :completed)
        end

        it "新規は「テストを開始する」が表示される" do
          get quizzes_path
          expect(response.body).to include("テストを開始する")
        end

        it "完了は「もう一度受ける」が表示される" do
          get quizzes_path
          expect(response.body).to include("もう一度受ける")
        end
      end
    end
  end

  describe "GET /quizzes/:id" do
    let(:quiz) do
      q = create(:quiz, title: "ルネサンスの文化と芸術")
      q.update_column(:published_at, 1.day.ago)
      q
    end
    let!(:question) { create(:question, body: "ルネサンス発祥の地は？", quiz: quiz) }
    let!(:choice_correct) { create(:choice, body: "フィレンツェ", correct_answer: true, question: question) }
    let!(:choice_wrong) { create(:choice, body: "ローマ", correct_answer: false, question: question) }

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get quiz_path(quiz)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before { sign_in user }

      it "正常にレスポンスを返す" do
        get quiz_path(quiz)
        expect(response).to have_http_status(:ok)
      end

      it "クイズのタイトルが表示される" do
        get quiz_path(quiz)
        expect(response.body).to include("ルネサンスの文化と芸術")
      end

      it "問題文が表示される" do
        get quiz_path(quiz)
        expect(response.body).to include("ルネサンス発祥の地は？")
      end

      it "選択肢が表示される" do
        get quiz_path(quiz)
        expect(response.body).to include("フィレンツェ")
        expect(response.body).to include("ローマ")
      end

      it "存在しないクイズは404を返す" do
        get quiz_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end

      it "非公開クイズは404を返す" do
        draft = create(:quiz, title: "下書きクイズ")
        get quiz_path(draft)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
