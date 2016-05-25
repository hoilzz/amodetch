class AddEvaluationsToValuations < ActiveRecord::Migration
  def change
    add_column :valuations, :grade, :integer
    add_column :valuations, :workload, :integer
    add_column :valuations, :level, :integer
    add_column :valuations, :achievement, :integer
    add_column :valuations, :homework, :integer
    add_column :valuations, :total, :integer
  end
end
