class AddEnrollmentsBelongsToTimetables < ActiveRecord::Migration
  def change
	#add_column :enrollments, :timetable_id, :integer
	add_reference :enrollments, :timetable, index: true, foreign_key: true
  end
end
  