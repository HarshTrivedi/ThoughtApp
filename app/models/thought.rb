class Thought < ActiveRecord::Base
  
  attr_accessible :thought_id, :content, :title, :tag, :private

  belongs_to :user

  validates :content, :presence =>true

end
