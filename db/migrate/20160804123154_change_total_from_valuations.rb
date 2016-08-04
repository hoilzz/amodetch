class ChangeTotalFromValuations < ActiveRecord::Migration
  def change
    rename_column :valuations, :total, :rating
  end
end
