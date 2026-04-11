class CreateStudyUnitSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :study_unit_schedules do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :study_unit, null: false, foreign_key: true

      t.timestamps
    end

    add_index :study_unit_schedules, [:schedule_id, :study_unit_id], unique: true
  end
end
