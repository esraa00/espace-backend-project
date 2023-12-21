module Types
  class SignInInputType < BaseInputObject
    argument :usernameOrEmail, String, required: true
    argument :password, String, required: true
  end
end