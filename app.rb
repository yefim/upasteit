require 'sinatra'
require 'sinatra/respond_with'
require 'json'
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
  # single query that shit?
  # check http://datamapper.org/docs/find.html
  # query = 'SELECT pastes.id, content, created_at FROM pastes, users WHERE users.id = pastes.user_id AND users.name = ? ORDER BY "created_at" DESC'
  # pastes = repository(:default).adapter.select(query, name)
  if u = User.first(name: name)
    options = { order: [:created_at.desc] }
    options[:limit] = Integer(howmany) if Integer(howmany) rescue nil
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
