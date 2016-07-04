class RemoveDumpFromTables < ActiveRecord::Migration
  def change
    #remove_index :comment_valuations, :lecture_id
    #remove_index :comment_valuations, :index_comment_valuations_on_comment_id_and_user_id
    #remove_index :comments, :index_comments_on_user_id_and_created_at
    remove_column :enrollments, :day
    remove_column :lectures, :acc_grade
    remove_column :lectures, :acc_workload
    remove_column :lectures, :acc_level
    remove_column :lectures, :acc_achievement
    remove_column :lectures, :acc_homework
    remove_index :users, :email

    remove_column :valuations, :up
    remove_column :valuations, :down
    remove_column :valuations, :grade
    remove_column :valuations, :workload
    remove_column :valuations, :level
    remove_column :valuations, :achievement
    remove_column :valuations, :homework


  end
end
