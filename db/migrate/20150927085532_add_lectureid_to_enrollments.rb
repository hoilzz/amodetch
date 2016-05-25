class AddLectureidToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :lecture_id, :integer
  end
end
