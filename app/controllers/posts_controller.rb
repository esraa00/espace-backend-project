class PostsController < ApplicationController
  respond_to :json
  before_action :authenticate_user!, only: [:create, :update]
  before_action :create_post_params, only: [:create]
  before_action :update_post_params, only: [:update]
  before_action :destroy_post_params, only: [:destroy]
  before_action :show_post_params, only: [:show]

  def index
    @posts = Post.page(params[:page])
    serialized_posts = @posts.map do |post|
      serialize_post(post)
    end
    render json: { posts: serialized_posts }
  end

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

  #TODO: fix this one, total miss
  #post .attribues, without begin 
  def update
    authorize params[:post][:user_id], policy_class: UserPolicy
    @post = Post.find(id: params[:post][:id]) # use find instead
    authorize @post, policy_class: PostPolicy
    @post.update(title: params[:post][:title], body: params[:post][:body])
    @post.tags << Tag.find(params[:post][:tags_ids]) if params[:post][:tags_ids].present?
    begin
      puts "category is #{params[:post][:category_id]}"
      if params[:post][:category_id].present?
        @category = Category.find(params[:post][:category_id])
        @post.category = @category
      end
    rescue ActiveRecord::RecordNotFound => e
      return render json: { message: "Couldn't update post", errors: [e.message] }, status: :not_found
    end
    # if @post.save
    # else @post.errors
    head :no_content
  end

  def destroy
    if current_user.id.to_s != params[:user_id].to_s
      return head :unauthorized
    end
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      return head :not_found
    end
    authorize @post, policy_class: PostPolicy
    if @post.destroy!
      return head :no_content
    end
  end

  #TODO: how does the user, tags and category came with the user without I called include as above
  def show
    @post = Post.find(params[:id])
    @serialized_post = serialize_post(@post)
    return render json: { post: @serialized_post}
  end

  private
  def serialize_post(post)
    serialized_post = PostSerializer.new(post).serializable_hash[:data][:attributes]
    serialized_post[:category] = post.category.nil? ? nil : CategorySerializer.new(post.category).serializable_hash[:data][:attributes]
    serialized_post[:user] = UserSerializer.new(post.user).serializable_hash[:data][:attributes]
    serialized_post[:tags] = post.tags.map do |tag|
      serialized_tag = TagSerializer.new(tag).serializable_hash[:data][:attributes]
    end
    serialized_post
  end

  def create_post_params
    params.require(:post).permit(:title, :body, :category_id, :tags_ids)
  end

  def update_post_params
    params.require(:post).permit(:id, :user_id, :title, :body, :category_id, :tags_ids)
  end

  def destroy_post_params
    params.permit(:id, :user_id)
  end

  def show_post_params
    params.permit(:id)
  end

  def index_post_params
    params.permit(:page)
  end
end