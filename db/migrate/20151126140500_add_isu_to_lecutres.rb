class AddIsuToLecutres < ActiveRecord::Migration
  def change
  	add_column :lectures, :isu, :string
  end
end
