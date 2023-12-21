class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :display_name, :email, :avatar, :created_at, :updated_at
end