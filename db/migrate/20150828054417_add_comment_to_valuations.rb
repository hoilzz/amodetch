class AddCommentToValuations < ActiveRecord::Migration
  def change
    add_column :valuations, :content, :text
  end
end
