require './config/environment'

class UserController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/signup" do
    if logged_in?
      redirect "/tweets"
    else
        erb :"/users/create_user"
    end
  end

  post "/signup" do
    user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.save
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/signup"
    end
  end

  get "/login" do
     if logged_in?
      redirect "/tweets"
    else
      erb :"/users/login"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  get "/logout" do
     if logged_in?
         session.clear
         redirect "/login"
    else
      redirect "/"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end #helpers

end