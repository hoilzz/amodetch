class RemoveSomeColumnsFromLectures < ActiveRecord::Migration
  def change
    remove_column :lectures, :lecturetime, :string
    remove_column :lectures, :place, :string
  end
end
