# a mock data source
class Post
  include DataMapper::Resource

  property :id,       Serial, key: true # auto-increment integer key
  property :title,    String, :required => true
  property :body,     Text

end
