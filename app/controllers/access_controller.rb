class AccessController < ApplicationController
  
  layout 'logged_in'

  before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]




  def index
  	login
  	render('login')
  end	

  def home
      render('thoughts/show')
  end	


  def login
  	#login form
  end

  def attempt_login
    @username = params[:username]
    @password = params[:password]

    authorized_user = User.authenticate(@username,@password)

  	if authorized_user
  		
  		session[:user_id] = authorized_user.id
  		session[:profile_name] = authorized_user.profile_name
  		flash[:notice] = "You are now logged in"
		  redirect_to(:controller => 'thoughts' ,:action => 'show', :profile_name => @username)

  	else
  		flash[:alert] = "Invalid username/password combination"
  		redirect_to(:action => 'login')
  	end


  end


  def logout
	session[:user_id] = nil
	session[:profile_name] = nil
  	flash[:notice] = "You have been loged out."
  	redirect_to(:action => "login")
  end


  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please Log In."
      redirect_to(:action => 'login')
      return false
    else
      return true
    end
  end

end
