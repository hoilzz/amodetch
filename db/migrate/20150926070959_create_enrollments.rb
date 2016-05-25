class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :begin_time
      t.string :end_time
      t.timestamps null: false
    end
  end
end