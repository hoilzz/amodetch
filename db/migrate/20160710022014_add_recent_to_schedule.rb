class AddRecentToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :recent, :boolean
  end
end
