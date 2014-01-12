class UserController < ApplicationController

  layout 'logged_in'

   def index
    list
    render('new')
  end
  

  def show
    @profile_name = params[:profile_name]
    @user = User.find_by_profile_name(@profile_name)
  end


  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.valid?
      UserMailer.welcome_email(@user).deliver
      @user.create_hashed_password(params[:user][:password])
      @user.save
      flash[:notice] = 'User created.'
      redirect_to(:controller => 'access',:action => 'login')
    else
      render("new")
    end
  end

  def edit
    @profile_name = params[:profile_name]
    @user = User.find_by_profile_name(@profile_name)
  end
  
  def update
    @user = User.find_by_profile_name(params[:profile_name])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User updated.'
      redirect_to(:controller =>'user' , :action => 'show', :profile_name => @user.profile_name)
    else
      render("edit")
    end
  end

  def delete
    @user = User.find_by_profile_name(params[:profile_name])
  end

  def destroy
    
    if params[:confirmation] == 'Yes'
      User.find_by_profile_name(params[:profile_name]).destroy
      flash[:notice] = "Your account is destroyed!"
      session[:user_id] = nil
      session[:profile_name] = nil
      redirect_to(:controller => 'access' , :action => 'login')
    else
      flash[:notice] = "Your account was not destroyed!"
      redirect_to(:controller => 'access' , :action => 'home')
      end

  end

  def update_followings
    @to_be_done = params[:value]
    
    @left_profile_name= params[:left_profile_name]
    @right_profile_name= params[:right_profile_name]

    @left_user = User.find_by_profile_name(@left_profile_name)
    @right_user = User.find_by_profile_name(@right_profile_name)

    if @to_be_done == 'follow'

#      @right_user.followers << @left_user
        @left_user.follow!(@right_user)
    else
#      Relationship.find_by_followed_id(@right_user.id)
#      @right_user.relationships.find_by_followed_id(@left)
        @left_user.unfollow!(@right_user)
    end
    redirect_to(:controller => 'user' , :action => 'show' , :profile_name => @right_profile_name)
  end

  def show_search_results_from_all_users
    @search_tag = params[:search_tag]
    @user = User.where(["profile_name like ? OR first_name like ? OR last_name like ?" , "%" + "#{@search_tag}" + "%" , "%" + "#{@search_tag}" + "%" ,  "%" + "#{@search_tag}" + "%"])
  end  

  def show_search_results_from_followers
    @search_tag = params[:search_tag]
    this_user = User.find_by_profile_name(session[:profile_name])
    @user = this_user.followers.where(["profile_name like ? OR first_name like ? OR last_name like ?" , "%" + "#{@search_tag}" + "%" , "%" + "#{@search_tag}" + "%" ,  "%" + "#{@search_tag}" + "%"])
  end  

  def show_search_results_from_followings
    @search_tag = params[:search_tag]
    this_user = User.find_by_profile_name(session[:profile_name])
    @user = this_user.following.where(["profile_name like ? OR first_name like ? OR last_name like ?" , "%" + "#{@search_tag}" + "%" , "%" + "#{@search_tag}" + "%" ,  "%" + "#{@search_tag}" + "%"])
  end  

end
