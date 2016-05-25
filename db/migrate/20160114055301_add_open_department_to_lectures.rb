class AddOpenDepartmentToLectures < ActiveRecord::Migration
  def change
  	add_column :lectures, :open_department, :string
  end
end
