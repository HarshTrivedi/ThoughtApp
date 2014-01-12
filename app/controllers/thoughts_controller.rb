class ThoughtsController < ApplicationController


layout 'logged_in'

   def index
    list
    render('new')
  end
  

  def show
    @profile_name = session[:profile_name]
    @user = User.find_by_profile_name(@profile_name)
    @thought = @user.thoughts

  end

  def show_thoughts_from_others
    # @profile_name = session[:profile_name]
    # @user = User.find_by_profile_name(@profile_name)
    # @thought = @user.thoughts

  end


  def new
    @thought = Thought.new
  end
  
  def create
    @profile_name = session[:profile_name]
    @user = User.find_by_profile_name(@profile_name)
    @thought = Thought.new(params[:thought])
    if @user.thoughts << @thought
      flash[:notice] = 'Thought created.'
      redirect_to(:controller => 'thoughts',:action => 'show')
    else
      render("new")
    end
  end

  def edit
    @id = params[:id]
    @thought = Thought.find_by_id(@id)

  end
  
  def update
    @thought = Thought.find_by_id(params[:id])

    if @thought.update_attributes(params[:thought])
      flash[:notice] = 'Thought updated.'
      redirect_to(:controller =>'thoughts' , :action => 'show')
    else
      render("edit")
    end
  end


  def destroy
      Thought.find_by_id(params[:thought_id]).destroy
      flash[:notice] = "Your thought is destroyed!"
      redirect_to(:controller => 'thoughts',:action => 'show')
  end

  def show_by_id
    @thought = Thought.find_by_id(params[:id])
    # if @user == nil
    #   flash[:alert] = "No such thought is found!"
    #   redirect_to(:controller => 'thoughts',:action => 'show')    
    # end       
  end


  def show_search_results_from_all_thoughts
    @search_tag = params[:search_tag]
    @thought = Thought.where(["tag like ? OR title like ?" , "%" + "#{@search_tag}" + "%" , "%" + "#{@search_tag}" + "%" ])
  end



  def show_search_results_from_my_thoughts
    @search_tag = params[:search_tag]
    @this_user = User.find_by_profile_name(session[:profile_name])
    @thought = @this_user.thoughts.where(["tag like ? OR title like ?" , "%" + "#{@search_tag}" + "%" , "%" + "#{@search_tag}" + "%" ])

   end

  def show_search_results_from_followings
    @search_tag = params[:search_tag]
    @this_user = User.find_by_profile_name(session[:profile_name])
    @followings = @this_user.following

   end



end