class AddIndexToScheduledetails < ActiveRecord::Migration
  def change
    add_index :schedule_details, :schedule_id
  end
end
