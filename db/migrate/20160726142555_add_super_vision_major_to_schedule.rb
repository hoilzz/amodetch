class AddSuperVisionMajorToSchedule < ActiveRecord::Migration
  def change
    
    add_column :schedules, :supervision_major, :string
  end
end
