class AddLikedcountToComments < ActiveRecord::Migration
  def change
  		add_column :comments, :likedcount, :integer, default: 0
  end
end

