class AddResetInfoToUser < ActiveRecord::Migration
  def up
  	add_column("users", "recent_reset_request", :boolean)
  	add_index("users","recent_reset_request")
  end

  def down
  	remove_index("users","recent_reset_request")
  	remove_column("users", "recent_reset_request")
  end
end