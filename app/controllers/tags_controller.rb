class TagsController < ApplicationController
  respond_to :json

  def index
    @tags = Tag.all
    serialized_tags = @tags.map do |tag|
      serialize_tag(tag)
    end
    puts "tags are #{serialized_tags}"
    render json: { tags: serialized_tags }
  end
end

private 

def serialize_tag(tag)
  serialized_tag = TagSerializer.new(tag).serializable_hash[:data][:attributes]
end