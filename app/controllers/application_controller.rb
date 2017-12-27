require './config/environment'

class ApplicationController < Sinatra::Base

  def self.current_user(session)
    @user = User.find_by_id(session[:user_id])
  end

  def self.is_logged_in?(session)
    !!session[:user_id]
  end

  def slug
    self.username.downcase.gsub(/[ ]/, "-")
  end

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
    User.is_logged_in?(session) ? (redirect to '/tweets') : (erb :'/users/login')
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user != nil && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/tweets"
    end
    erb :'/users/login'
  end

  get '/signup' do
    if User.is_logged_in?(session)
      @user = User.find(session[:user_id])
      (redirect to "/tweets")
    end
    (erb :'/users/create_user')
  end

  post '/signup' do
    if params[:username].empty? | params[:email].empty? | params[:password].empty?
      redirect to "/users/signup"
    end
    @user = User.new(username: params[:username])
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save
    session[:user_id] = @user.id
    redirect to "/tweets"
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  get '/tweets/new' do
    User.is_logged_in?(session) ? (erb :'/tweets/create_tweet') : (redirect to '/login')
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    end
    @tweet = Tweet.new(content: params[:content])
    @tweet.user_id = session[:user_id]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets' do
    if User.is_logged_in?(session)
      @tweets = Tweet.all
      @user = User.find(session[:user_id])
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get "/tweets/:id" do
    if User.is_logged_in?(session)
      @tweet = Tweet.find(params[:id].to_i)
      erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if User.is_logged_in?(session)
      @user = User.find(session[:user_id])
      if Tweet.find(params[:id].to_i).user_id == session[:user_id]
        @tweet = Tweet.find(params[:id].to_i)
        erb :'/tweets/edit_tweet'
      end
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id].to_i)
    if params[:content].empty?
      redirect to "/tweets/#{@tweet.id}/edit"
    end
    @tweet.content = params[:content]
    @tweet.user_id = session[:user_id]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id/delete' do
    if User.is_logged_in?(session)
      @tweet = Tweet.find(params[:id].to_i)
      if @tweet.user_id == session[:user_id]
        Tweet.destroy(params[:id].to_i)
      end
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

end
