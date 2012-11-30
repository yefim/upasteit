require 'sinatra'
require_relative 'models'

get '/' do
  erb :index
end

get '/:name' do |name|
  @pastes = User.first_or_create(name: name).pastes
  erb :pastes
end

post '/:name' do |name|
  @p = User.first_or_create(name: name).pastes.create(content: params[:paste])
  # should either return json or render :pastes depending on incoming format
  content_type :json
  @p.to_json
end
