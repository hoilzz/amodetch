class CreateTimetableItems < ActiveRecord::Migration
  def change
    create_table :timetable_items do |t|
      t.integer :lecture_id
      t.integer :schedule_id
      t.integer :timetable_id
      t.timestamps null: false
    end
  end
end
