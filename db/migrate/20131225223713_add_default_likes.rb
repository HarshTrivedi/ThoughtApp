class AddDefaultLikes < ActiveRecord::Migration
  def up
  	change_column("users", "likes", :integer, :default => 0)
  	change_column("thoughts", "likes", :integer, :default => 0)
  end

  def down
  	change_column("users", "likes", :integer)
  	change_column("thoughts", "likes", :integer)
  end
end
