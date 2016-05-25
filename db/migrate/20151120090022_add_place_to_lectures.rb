class AddPlaceToLectures < ActiveRecord::Migration
  def change
  	add_column :lectures, :place, :string
  end
end
