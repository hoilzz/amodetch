class AddCreditToLectures < ActiveRecord::Migration
  def change
  	    add_column :lectures, :credit, :float
  end
end
