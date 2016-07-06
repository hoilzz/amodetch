class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :lecturetime
      t.string :semester
      t.timestamps null: false
    end
  end
end
