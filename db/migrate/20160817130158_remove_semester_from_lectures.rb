class RemoveSemesterFromLectures < ActiveRecord::Migration
  def change
    remove_column :lectures, :semester
  end
end
