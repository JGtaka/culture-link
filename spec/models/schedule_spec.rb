require "rails_helper"

RSpec.describe Schedule, type: :model do
  describe "バリデーション" do
    it "全ての属性が正しければ有効" do
      schedule = build(:schedule)
      expect(schedule).to be_valid
    end

    it "開始日がなければ無効" do
      schedule = build(:schedule, start_date: nil)
      expect(schedule).not_to be_valid
    end

    it "終了日がなければ無効" do
      schedule = build(:schedule, end_date: nil)
      expect(schedule).not_to be_valid
    end

    it "目標学習時間がなければ無効" do
      schedule = build(:schedule, daily_study_hours: nil)
      expect(schedule).not_to be_valid
    end

    it "目標学習時間が0以下なら無効" do
      schedule = build(:schedule, daily_study_hours: 0)
      expect(schedule).not_to be_valid
    end

    it "目標学習時間が13以上なら無効" do
      schedule = build(:schedule, daily_study_hours: 13)
      expect(schedule).not_to be_valid
    end

    it "終了日が開始日より前なら無効" do
      schedule = build(:schedule, start_date: Date.today, end_date: Date.yesterday)
      expect(schedule).not_to be_valid
    end

    it "終了日と開始日が同じなら無効" do
      schedule = build(:schedule, start_date: Date.today, end_date: Date.today)
      expect(schedule).not_to be_valid
    end

    it "ユーザーがなければ無効" do
      schedule = build(:schedule, user: nil)
      expect(schedule).not_to be_valid
    end
  end

  describe "#weekdays=" do
    it "nilや空文字を除外して保存する" do
      schedule = build(:schedule, weekdays: [ nil, "", "0", 1, 2 ])
      expect(schedule.weekdays).to eq([ 0, 1, 2 ])
    end

    it "nilのみ渡された場合は空配列になる" do
      schedule = build(:schedule, weekdays: [ nil, "" ])
      expect(schedule.weekdays).to eq([])
    end

    it "nilが渡された場合は空配列になる" do
      schedule = build(:schedule, weekdays: nil)
      expect(schedule.weekdays).to eq([])
    end
  end

  describe "アソシエーション" do
    it "study_unitsを紐付けられる" do
      schedule = create(:schedule)
      unit = create(:study_unit)
      schedule.study_units << unit
      expect(schedule.study_units).to include(unit)
    end

    it "削除時にstudy_unit_schedulesも削除される" do
      schedule = create(:schedule)
      create(:study_unit_schedule, schedule: schedule)
      expect { schedule.destroy }.to change(StudyUnitSchedule, :count).by(-1)
    end
  end
end
