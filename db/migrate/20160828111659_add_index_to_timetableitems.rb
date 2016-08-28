class AddIndexToTimetableitems < ActiveRecord::Migration
  def change
    add_index :timetable_items, :timetable_id
  end
end
