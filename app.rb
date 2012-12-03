require 'sinatra'
require 'sinatra/respond_with'
require 'json'
require 'debugger'
require_relative 'models'

get '/' do
  respond_to do |format|
    format.html { erb :index }
    format.json { '{"upasteit": "wesaveit"}' }
  end
end

post '/' do
  content_type :json
  {upasteit: "wesaveit"}.to_json
end

get '/:name/?:howmany?' do |name, howmany|
  if u = User.first(name: name)
    options = {}
    options[:order] = [:created_at.desc]
    options[:limit] = Integer(howmany) if howmany
    @pastes = u.pastes(options)
  else
    User.create(name: name)
    @pastes = []
  end
  respond_to do |format|
    format.html { erb :pastes }
    format.json { @pastes.to_json }
  end
end

post '/:name/?:howmany?' do |name, howmany|
  pastes = User.first_or_create(name: name).pastes
  if params[:paste].kind_of?(Array)
    @pastes = params[:paste].map { |paste| pastes.create(content: paste) }
  else
    @pastes = pastes.create(content: params[:paste])
  end
  respond_to do |format|
    format.html { redirect "/#{name}" + (howmany ? "/#{howmany}" : "") }
    format.json { @pastes.to_json }
  end
end
