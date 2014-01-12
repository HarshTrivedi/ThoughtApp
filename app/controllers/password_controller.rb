class PasswordController < ApplicationController


layout 'logged_in'

	def request_update

	end

	def send_link
		@email = params[:email_address]
		@user = User.find_by_email_address(@email)
	
		if @user !=nil
			UserMailer.update_password_request(@email).deliver
			flash[:notice] = "Instructions for changing password, sent to your email."
			redirect_to(:controller => 'access', :action => "login")
		else
			flash[:alert] = "Sorry, This email is not registerd, retry!"
			render('request_update')
		end

	end

	def change_password_form
		
	end

	def update_password
		@email_address = params[:email_address]
		@password = params[:password]
		@password_confirmation = params[:password_confirmation]
		@user = User.find_by_email_address(@email_address)
		@this_user = User.find_by_profile_name(session[:profile_name])

			if session[:profile_name] == nil
				if @password != @password_confirmation
					redirect_to(:controller => 'password' , :action => 'change_password_form' , :error => 'mismatch')
					return
				end

				if @password.size < 5
					redirect_to(:controller => 'password' , :action => 'change_password_form' , :error => 'too short')
					return
				end
				if @password.size > 15
					redirect_to(:controller => 'password' , :action => 'change_password_form' , :error => 'too long')
					return
				end
				if @user == nil
							flash[:alert] = "Sorry, This email is not registerd, retry!."
							redirect_to(:controller => 'password' , :action => 'change_password_form' )	
					return false		
				end
				if @user.recent_reset_request == true
						@user.recent_reset_request = false
						@user.create_hashed_password(@password)
						if @user.save				
							flash[:notice] = "Password updated"
							if @this_user == @user
								flash[:notic] = "Password updated successfully"
								redirect_to(:controller => 'user' , :action => 'edit' , :profile_name => @this_user.profile_name)				
							else
								redirect_to(:controller => 'access' , :action => 'login')
							end
						else	 
							flash[:alert] = "Some internal Problem has occured."
							redirect_to(:controller => 'access' , :action => 'login')					
						end	
				else
						flash[:alert] = "Sorry, you are not authorized, Try clicking the link once again"
						redirect_to(:controller => 'password' , :action => 'change_password_form')
				end	
			else
				########if session is present
				if @password != @password_confirmation
					redirect_to(:controller => 'user' , :action => 'edit' , :error => 'mismatch' , :profile_name => @this_user.profile_name)
					return
				end

				if @password.size < 5
					redirect_to(:controller => 'user' , :action => 'edit' , :error => 'too short' , :profile_name => @this_user.profile_name)
					return
				end
				if @password.size > 15
					redirect_to(:controller => 'user' , :action => 'edit' , :error => 'too long' , :profile_name => @this_user.profile_name)
					return
				end

				@this_user.recent_reset_request = false
				@this_user.create_hashed_password(@password)
				if @this_user.save				
					flash[:notice] = "Password updated successfully"
					redirect_to(:controller => 'user' , :action => 'edit' , :profile_name => @this_user.profile_name)
				else	 
					flash[:alert] = "Some internal Problem has occured."
					redirect_to(:controller => 'user' , :action => 'edit' , :profile_name => @this_user.profile_name)					
				end	

			end



	end

end
