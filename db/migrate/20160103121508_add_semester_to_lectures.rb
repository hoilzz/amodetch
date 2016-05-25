class AddSemesterToLectures < ActiveRecord::Migration
  def change
  		add_column :lectures, :semester, :string
  end
end
