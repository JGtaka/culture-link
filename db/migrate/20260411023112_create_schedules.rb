class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :daily_study_hours, null: false, default: 1
      t.integer :weekdays, array: true, default: []
      t.text :memo

      t.timestamps
    end
  end
end
