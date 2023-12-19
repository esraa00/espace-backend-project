class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_create_post_params, only: [:create]

  def create
    @post = current_user.posts.build({title: params[:post][:title], body: params[:post][:body], user_id: current_user.id})
    if @post.save
      begin
        if !params[:post][:tags_ids].nil?
          params[:post][:tags_ids].each do |tagId|
            @post.tags << Tag.find(tagId)
          end
        end
        @post.category = Category.find(params[:post][:category_id]) unless params[:post][:category_id].nil?
        serialized_post = serialize_post(@post)
        render json: { message: "Post created successfully!", post: serialized_post, errors:[]}, status: :created
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: [e.message], post: nil, message: "Couldn't create post" }, status: :unprocessable_entity
    end
    else
      render json: { errors: @post.errors.full_messages, post: nil, message: "Couldn't create post" }, status: :unprocessable_entity
    end
  end

  private
  
  def serialize_post(post)
    serialized_post = PostSerializer.new(post).serializable_hash[:data][:attributes]
    serialized_post[:category] = post.category.nil? ? nil : CategorySerializer.new(post.category).serializable_hash[:data][:attributes]
    serialized_post[:tags] = post.tags.map do |tag|
      serialized_tag = TagSerializer.new(tag).serializable_hash[:data][:attributes]
      {
          tagId: serialized_tag[:id],
          name: serialized_tag[:name]
      }
    end
    serialized_post
  end

  def set_create_post_params
    params.require(:post).permit(:title, :body, :category_id, :tags_ids)
  end

end