class AddLikesInThought < ActiveRecord::Migration
  def up
  	add_column("thoughts", "likes", :integer)
  end

  def down
  	remove_column("thoughts", "likes")
  end
end
