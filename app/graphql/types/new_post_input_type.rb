module Types
  class NewPostInputType < BaseInputObject
    argument :title, String
    argument :body, String
    argument :user_id, ID
    argument :tags_ids,[ID], required: false
    argument :category_id, ID, required: false
  end
end