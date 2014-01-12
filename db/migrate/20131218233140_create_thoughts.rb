class CreateThoughts < ActiveRecord::Migration
  	def change
	    create_table :thoughts do |t|
		      t.references :user
		      t.text "content"
		      t.boolean "private", :default => true
		      t.timestamps
		  end 
    end
end
