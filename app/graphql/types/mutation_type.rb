# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Signup
    field :login , mutation: Mutations::Login
  end
end
