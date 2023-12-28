# frozen_string_literal: true

module Types
  class CurrentUserType < Types::BaseObject
    field :id, ID
    field :username, String
    field :email, String
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
    field :display_name, String
    field :avatar, String
    field :errors, [String]
  end
end
