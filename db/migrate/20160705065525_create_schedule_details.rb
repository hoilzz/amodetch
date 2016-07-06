class CreateScheduleDetails < ActiveRecord::Migration
  def change
    create_table :schedule_details do |t|
      t.belongs_to :schedule
      t.string :start_time
      t.string :end_time
      t.string :day
      t.timestamps null: false
    end
  end
end
