require 'sinatra'
require 'sinatra/respond_with'
require_relative 'models'

get '/' do
  erb :index
end

get '/:name' do |name|
  if u = User.first(name: name)
    @pastes = u.pastes
  else
    User.create(name: name)
    @pastes = []
  end
  # should either return json or render :pastes depending on incoming format
  erb :pastes
  respond_to do |format|
    format.html { erb :pastes }
    format.json { @pastes.to_json }
  end
end

post '/:name' do |name|
  @paste = User.first_or_create(name: name).pastes.create(content: params[:paste])
  # should either return json or render :pastes depending on incoming format
  respond_to do |format|
    format.html { redirect "/#{name}" }
    format.json { @paste.to_json }
  end
end
