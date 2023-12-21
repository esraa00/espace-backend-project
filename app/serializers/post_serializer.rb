class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
end
