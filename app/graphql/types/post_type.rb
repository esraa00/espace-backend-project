module Types
  class PostType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String, null: false
    field :category, CategoryType
    field :user, String, null: false
    field :tags, [TagType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end