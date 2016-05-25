class AddDaysToEnrollments < ActiveRecord::Migration
  def change
  	add_column :enrollments, :days, :string
  end
end
