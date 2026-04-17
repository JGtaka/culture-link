class AddTimestampsToMissingTables < ActiveRecord::Migration[7.2]
  def change
    %i[characters events periods study_units event_characters].each do |table|
      add_timestamps table, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
