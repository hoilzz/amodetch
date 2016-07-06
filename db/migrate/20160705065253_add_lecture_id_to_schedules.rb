class AddLectureIdToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :lecture_id, :integer
  end
end
