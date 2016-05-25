class AddLecturetimeToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :lecturetime, :string
  end
end
