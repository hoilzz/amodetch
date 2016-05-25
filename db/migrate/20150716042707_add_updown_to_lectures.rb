class AddUpdownToLectures < ActiveRecord::Migration
  def change
  	add_column :lectures, :uptachi, :integer, default: 0
  	add_column :lectures, :hatachi, :integer, default: 0
  end
end
