class AddIndexToValuation < ActiveRecord::Migration
  def change
    add_index :valuations, :lecture_id
  end
end
