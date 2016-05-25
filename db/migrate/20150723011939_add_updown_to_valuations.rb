class AddUpdownToValuations < ActiveRecord::Migration
  def change
	add_column :valuations, :up, :integer, default: 0
	add_column :valuations, :down, :integer, default: 0
  end
end
