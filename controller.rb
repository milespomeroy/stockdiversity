require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

get '/' do
  @title = "Stock Diversity"
  haml :login
end

# hack for now to make login form work
post '/loggedin' do
  redirect '/loggedin'
end

# TODO: use this when logged in
get '/loggedin' do
  @title = "Stock Diversity"
  haml :index
end

get '/detail' do
  @title = "cvP51P/FM7"
  haml :detail
end

get '/edit' do
  @title = "Edit (125) &mdash; cvP51P/FM7"
  haml :edit
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

