require "rails_helper"

RSpec.describe StudyUnitSchedule, type: :model do
  describe "バリデーション" do
    it "スケジュールと学習単元があれば有効" do
      study_unit_schedule = build(:study_unit_schedule)
      expect(study_unit_schedule).to be_valid
    end

    it "同じスケジュールに同じ学習単元を重複登録できない" do
      schedule = create(:schedule)
      unit = create(:study_unit)
      create(:study_unit_schedule, schedule: schedule, study_unit: unit)
      duplicate = build(:study_unit_schedule, schedule: schedule, study_unit: unit)
      expect(duplicate).not_to be_valid
    end

    it "異なるスケジュールに同じ学習単元を登録できる" do
      unit = create(:study_unit)
      create(:study_unit_schedule, schedule: create(:schedule), study_unit: unit)
      study_unit_schedule = build(:study_unit_schedule, schedule: create(:schedule), study_unit: unit)
      expect(study_unit_schedule).to be_valid
    end
  end
end
