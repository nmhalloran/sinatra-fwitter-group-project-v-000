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
    if @user != nil # && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect to '/tweets'
    end

    erb :'/users/login'
  end

  get '/signup' do
    if User.is_logged_in?(session)
      (redirect to "/tweets/new")
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
    session[:user_id] = @user.id
    redirect to "/tweets"
  end

  get '/tweets' do
    @tweets = User.find(session[:user_id]).tweets.all
    erb :'/tweets/tweets'
  end

  get '/tweets/new' do
    @tweets = User.find(session[:user_id]).tweets.all
    erb :'/tweets/create_tweet'
  end

  post '/tweets' do
    binding.pry
    @tweet = Tweet.new(params[:content])
    @tweet.user_id = session[:user_id]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"

  end

  get '/tweets/:id/edit' do
    if User.is_logged_in?(session)
      @user = User.find(session[:user_id])
      if Tweet.find(:id).user_id == session.id
        erb :'/tweets/edit_tweet'
      end
    else
      redirect to '/login'
    end
  end

  get 'tweets/:id' do
    @tweet = Tweet.find(:id)
    erb :'/tweets/show_tweet'
  end

  post '/tweets/:id' do
    @tweet = Tweet.new(params[:content])
    @tweet.user_id = session[:user_id]
    erb :'/tweets/show_tweet'
  end

  post '/tweets/:id/delete' do

    @tweet = Tweet.find(params[:id].to_i)
    Tweet.destroy(params[:id].to_i)

  end

  get '/logout' do
    session.clear
    redirect to '/'
  end

end
