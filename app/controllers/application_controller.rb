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
    erb :login
  end

  post '/login' do
    @user = User.find(params)
    erb :'/users/#{@user.id}'
  end

  get '/signup' do
    erb :create_user.erb
  end

  post '/signup' do
    @user = User.create(params)
    erb :'/users/#{@user.id}'
  end

end
