class AddLikesInUser < ActiveRecord::Migration
  def up
  	add_column("users", "likes", :integer)
  end

  def down
  	remove_column("users", "likes")
  end
end
