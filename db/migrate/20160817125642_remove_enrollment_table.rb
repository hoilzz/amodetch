class RemoveEnrollmentTable < ActiveRecord::Migration
  def change
    drop_table :enrollments
    drop_table :plural_attrs
    drop_table :relationships
  end
end
