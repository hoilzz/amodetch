class AddMajorYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :year, :integer
    add_column :users, :major, :string
  end
end
