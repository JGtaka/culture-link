class CreateStudyUnits < ActiveRecord::Migration[7.2]
  def change
    create_table :study_units do |t|
      t.string :name
    end
  end
end
