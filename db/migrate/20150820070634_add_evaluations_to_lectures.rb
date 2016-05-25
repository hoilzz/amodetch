class AddEvaluationsToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :acc_grade, :float, default: 0
    add_column :lectures, :acc_workload, :float, default: 0
    add_column :lectures, :acc_level, :float, default: 0
    add_column :lectures, :acc_achievement, :float, default: 0
    add_column :lectures, :acc_homework, :float, default: 0
    add_column :lectures, :acc_total, :float, default: 0
  end
end
