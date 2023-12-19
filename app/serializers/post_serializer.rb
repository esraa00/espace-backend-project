class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :body
  # belongs_to :user
  # belongs_to :category, if: ->(record, _params) { record.user&.category.present? }
  # has_many :tags,if: ->(record, _params) { record.user&.tags.present? }
end
