class AlterThoughts < ActiveRecord::Migration
  def up
	add_column("thoughts", "tag", :string, :default => "", :limit => 40)
	add_column("thoughts", "title", :string, :default => "", :limit => 40)
	add_index("thoughts","tag")
  end

  def down
  	remove_index("thoughts","tag")
	remove_column("thoughts", "title")
	remove_column("thoughts", "tag")
  end
end
