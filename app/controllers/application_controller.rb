require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    User.is_logged_in?(session) ? (redirect to "/tweets") : (erb :index)
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params["username"]
    if @user != nil && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect to '/tweets'
    end

    erb :'/users/login'
  end

  get '/signup' do
    if User.is_logged_in?(session)
      (redirect to "/tweets")
    else
      (erb :'/users/create_user')
    end
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

  get '/tweets/new' do

  end

  post '/tweets' do

  end

  get '/tweets/:id/edit' do

  end

  post '/tweets/:id' do

  end

  post '/tweets/:id/delete' do

  end

end
