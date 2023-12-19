# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Signup
    field :signin , mutation: Mutations::Signin
    field :editUser, mutation: Mutations::EditUser
    field :createPost, mutation: Mutations::CreatePost
  end
end
