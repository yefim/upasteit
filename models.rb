require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/upasteit.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :pastes
end

class Paste
  include DataMapper::Resource

  property :id, Serial
  property :content, Text
end

DataMapper.auto_upgrade!
