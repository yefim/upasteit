require 'sinatra'
require_relative 'models'

get '/' do
  erb :index
end

get '/:name' do
  @name = params[:name]
  @pastes = User.first_or_create(name: @name).pastes # if just created, @pastes should be [], user .saved? to check for creation
  erb :pastes
end

post '/:name' do
  @name = params[:name]
  @p = User.first_or_create(name: @name).pastes.create(content: params[:paste])
  content_type :json
  @p.to_json
end
