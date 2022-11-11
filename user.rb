require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")

class User  #there is going to be a table called 'users'
  include DataMapper::Resource
  property(:username, Text, :key => true)
  property(:password, Text)
  property(:totalwin, Integer)
  property(:totalloss, Integer)
  property(:totalprofit, Integer)  
end

DataMapper.finalize


