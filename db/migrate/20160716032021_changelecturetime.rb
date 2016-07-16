class Changelecturetime < ActiveRecord::Migration
  def change
    rename_column :schedules, :lecturetime, :lecture_time
  end
end
