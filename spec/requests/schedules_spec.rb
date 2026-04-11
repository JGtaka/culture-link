require "rails_helper"

RSpec.describe "Schedules", type: :request do
  let(:user) { create(:user) }
  let(:study_unit) { create(:study_unit) }

  describe "GET /schedules/new" do
    context "ログイン済みの場合" do
      before { sign_in user }

      it "新規作成フォームが表示される" do
        get new_schedule_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get new_schedule_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /schedules" do
    before { sign_in user }

    let(:valid_params) do
      {
        schedule: {
          start_date: Date.today,
          end_date: Date.today + 30.days,
          daily_study_hours: 2,
          weekdays: [0, 1, 2],
          memo: "テストメモ",
          study_unit_ids: [study_unit.id]
        }
      }
    end

    it "スケジュールを作成できる" do
      expect {
        post schedules_path, params: valid_params
      }.to change(Schedule, :count).by(1)
    end

    it "作成後プロフィールにリダイレクトされる" do
      post schedules_path, params: valid_params
      expect(response).to redirect_to(profile_path)
    end

    it "学習単元が紐付けられる" do
      post schedules_path, params: valid_params
      expect(Schedule.last.study_units).to include(study_unit)
    end

    it "不正なパラメータでは作成できない" do
      post schedules_path, params: { schedule: { start_date: nil, end_date: nil, daily_study_hours: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /schedules/:id/edit" do
    before { sign_in user }

    it "編集フォームが表示される" do
      schedule = create(:schedule, user: user)
      get edit_schedule_path(schedule)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /schedules/:id" do
    before { sign_in user }

    let!(:schedule) { create(:schedule, user: user) }

    it "スケジュールを更新できる" do
      patch schedule_path(schedule), params: { schedule: { daily_study_hours: 3 } }
      expect(schedule.reload.daily_study_hours).to eq(3)
    end

    it "更新後プロフィールにリダイレクトされる" do
      patch schedule_path(schedule), params: { schedule: { daily_study_hours: 3 } }
      expect(response).to redirect_to(profile_path)
    end
  end

  describe "DELETE /schedules/:id" do
    before { sign_in user }

    let!(:schedule) { create(:schedule, user: user) }

    it "スケジュールを削除できる" do
      expect {
        delete schedule_path(schedule)
      }.to change(Schedule, :count).by(-1)
    end

    it "削除後プロフィールにリダイレクトされる" do
      delete schedule_path(schedule)
      expect(response).to redirect_to(profile_path)
    end
  end
end
