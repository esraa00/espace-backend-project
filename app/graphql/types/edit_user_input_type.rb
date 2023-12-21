module Types
  class EditUserInputType < BaseInputObject
    #TODO: how can I include avatar?
    argument :id, String
    argument :display_name, String
    argument :username, String
    argument :email, String
    argument :current_password, String, required: false
    argument :new_password, String, required: false
    argument :new_password_confirmation, String, required: false
  end
end