class AlterUsers < ActiveRecord::Migration
  def up
  	rename_column("users","password","hashed_password")
  	add_column("users", "salt", :string, :limit => 40)
  	add_index("users","profile_name")
  end

  def down
  	remove_index("users","profile_name")
  	remove_column("users", "salt")
  	rename_column("users","hashed_password","password")
  end
end
