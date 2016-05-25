class CreateCommentValuations < ActiveRecord::Migration
  def change
    create_table :comment_valuations do |t|
    	t.boolean :like, default: false
    	t.references :user, index: true, foreign_key: true
    	t.references :comment, index: true, foreign_key: true
    	t.references :lecture, index: true, foreign_key: true
    	t.timestamps null: false
    end
    add_index :comment_valuations, [:comment_id, :user_id]
  end
end
