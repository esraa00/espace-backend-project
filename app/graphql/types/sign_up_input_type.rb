module Types
  class SignUpInputType < BaseInputObject
    argument :display_name, String, required: true
    argument :email, String , required: true
    argument :username, String , required: true
    argument :password, String , required: true
    argument :password_confirmation, String , required: true
  end
end