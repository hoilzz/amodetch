class AddSemesterToTimetables < ActiveRecord::Migration
  def change
		add_column :timetables, :semester, :string
  end
end
