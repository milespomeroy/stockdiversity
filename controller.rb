require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'sequel' # also need pg or postgres gems

DB = Sequel.connect(
  :adapter => 'postgres',
  :host => 'localhost',
  :port => 5432,
  :database => 'miles',
  :user => 'miles',
  :password => 'michellerocks',
  :default_schema => 'miles'
)

# Models TODO: separate out later
class User < Sequel::Model
end

# Controller
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
  @user = User.first #testing
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

