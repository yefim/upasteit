require 'sinatra'
require 'sinatra/respond_with'
require_relative 'models'

get '/' do
  erb :index
end

get '/:name' do |name|
  if u = User.first(name: name)
    @pastes = u.pastes(order: [:created_at.desc])
  else
    User.create(name: name)
    @pastes = []
  end
  respond_to do |format|
    format.html { erb :pastes }
    format.json { @pastes.to_json }
  end
end

post '/:name' do |name|
  @paste = User.first_or_create(name: name).pastes.create(content: params[:paste])
  respond_to do |format|
    format.html { redirect "/" + name }
    format.json { @paste.to_json }
  end
end
