# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Signup
    field :signin , mutation: Mutations::SigninMutation
    field :editUser, mutation: Mutations::EditUserMutation
    field :createPost, mutation: Mutations::CreatePost
    field :editPost, mutation: Mutations::EditPostMutation
    field :destroyPost, mutation: Mutations::DestroyPostMutation
  end
end
