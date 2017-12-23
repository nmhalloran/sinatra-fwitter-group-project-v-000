require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user != nil && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect to '/tweets'
    end

    erb :'/users/show'
  end

  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    if params[:username].empty? | params[:email].empty?| params[:password].empty?
      redirect to "/users/signup"
    end
    @user = User.new(username: params[:username])
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save

    redirect to "/tweets"
  end

end
