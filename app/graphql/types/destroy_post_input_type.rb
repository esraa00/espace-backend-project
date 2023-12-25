module Types
  class DestroyPostInputType < BaseInputObject
    argument :id, ID, required: true
    argument :user_id, ID , required: true
  end
end