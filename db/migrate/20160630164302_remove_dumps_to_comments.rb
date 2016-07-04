class RemoveDumpsToComments < ActiveRecord::Migration
  def change
    #remove_index :comment_valuations, :lecture_id
    #remove_index :comment_valuations, :comment_id
    #remove_index :comment_valuations, :user_id
    #remove_index :comment_valuations, column: ["comment_id", "user_id"]
    remove_index :enrollments, :timetable_id
  end
end
