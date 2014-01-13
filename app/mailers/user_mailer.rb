class UserMailer < ActionMailer::Base
  include SendGrid
  default from: 'harshjtrivedi94@gmail.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/user/create'
    mail(to: @user.email_address,
         subject: 'Welcome to My Awesome Site')
  end


  def update_password_request(email_address)
    @url  = 'http://localhost:3000/user/create'
    @user = User.find_by_email_address(email_address)
    @email = email_address
    
	    mail(to: email_address,
	         subject: 'Request To change Password @ThoughtApp.com')

  end

    def password_changed(email_address)
      @url  = 'http://localhost:3000/user/create'
      @user = User.find_by_email_address(email_address)
      @email = email_address
    
      mail(to: email_address,
           subject: 'Request To change Password @ThoughtApp.com')

  end

end
