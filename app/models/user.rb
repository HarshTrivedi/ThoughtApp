require 'digest/sha1'
class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :thoughts

  has_many :relationships, :dependent => :destroy, :foreign_key => 'follower_id'
  has_many :reverse_relationships, :dependent => :destroy, :foreign_key => 'followed_id', :class_name => "Relationship"

  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source => :follower

  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "10000x10000>", :thumb => "10000x10000>" , :default_url => "../../../default.jpg"}
  validates_attachment_size :avatar, :less_than => 100.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png','image/jpg']

  attr_accessor :password

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :first_name, :presence =>true
  validates :last_name, :presence =>true
  validates :profile_name, :presence =>true, :uniqueness =>true
  validates :email_address, :presence =>true, :uniqueness =>true, :format => EMAIL_REGEX

  validates_length_of :password, :within => 4..20, :on => :create
#  validates_length_of :password, :within => 4..20, :on => :update
  validates :password, :confirmation =>true

  before_save :create_hashed_password
  after_save :clear_password

  attr_protected :hashed_password, :salt

  def self.make_salt(username="")
  	Digest::SHA1.hexdigest("Use #{username} with Time.now to make salt")
  end

  def self.hash_with_salt(password="", salt="")
  	Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end



  def self.authenticate(profile_name="", password="")
  	user = User.find_by_profile_name(profile_name)
  	if user && user.password_match?(password)
  		return user
  	else
  		return false
  	end	
  end

  def password_match?(password="")
  	hashed_password == User.hash_with_salt(password,salt)
  end


  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end


#  private
  
  def create_hashed_password(password="")
  		unless  password.blank?
  			self.salt = User.make_salt(profile_name) if salt.blank?
  			self.hashed_password = User.hash_with_salt(password,salt)
	  	end	
  end


  def clear_password
  	self.password = nil
  end


end
