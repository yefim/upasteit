require 'sinatra'
require_relative 'models'

get '/' do
  erb :index
end

get '/:name' do |name|
  if user = User.first(name: name)
    new = false
  elsif user = User.create(name: name)
    new = true
  end
  @pastes = if new then [] else user.pastes end
  erb :pastes
end

post '/:name' do |name|
  @p = User.first_or_create(name: name).pastes.create(content: params[:paste])
  # should either return json or render :pastes depending on incoming format
  content_type :json
  @p.to_json
end
