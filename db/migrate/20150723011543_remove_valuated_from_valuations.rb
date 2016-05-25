class RemoveValuatedFromValuations < ActiveRecord::Migration
  def change
  	remove_column :valuations, :valuated, :integer
  end
end
