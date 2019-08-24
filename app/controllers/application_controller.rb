require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end
	#renders an index.erb file with links to signup or login.

	get "/signup" do
		erb :signup
	end
# renders a form to create a new user. The form includes fields for username and password.

	post "/signup" do
	user = User.new(:username => params[:username], :password => params[:password])
	#make a new instance of our user class with a username and password from params. Note that even though our database has a #column called password_digest, we still access the attribute of password. This is given to us by has_secure_password
	 if user.save
    redirect "/login"
  else
    redirect "/failure"
  end
  
	end

	get "/login" do
		erb :login
	end
#renders a form for logging in.

	post "/login" do
user = User.find_by(:username => params[:username])
 
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/success"
  else
    redirect "/failure"
  end
	end

	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end
	#renders a failure.erb page. This will be accessed if there is an error logging in or signing up.

	get "/logout" do
		session.clear
		redirect "/"
	end
	#clears the session data and redirects to the homepage.

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end

#BCrypt will store a salted, hashed version of our users' passwords in our database in a column called password_digest. Essentially, once a password is salted and hashed, there is no way for anyone to decode it. This method requires that hackers use a 'brute force' approach to gain access to someone's account –– still possible, but more difficult.