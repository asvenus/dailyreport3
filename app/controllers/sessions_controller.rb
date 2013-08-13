class SessionsController < ApplicationController

def new
end

def create
	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])&&user.active?
      	# Sign the user in and redirect to the user's page.
      	sign_in user
      	redirect_to root_url
    else
    	flash[:error] = 'Invalid email/password combination' 
    	render 'new'
    end
end

def destroy
    sign_out
    redirect_to root_url
end

end
