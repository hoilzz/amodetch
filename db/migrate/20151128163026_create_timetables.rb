class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|

    	t.belongs_to :user
    	t.string :name
 
    	t.timestamps null: false
    end
  end
end


 