class Mutations::CreatePost < Mutations::BaseMutation
  argument :post, Types::NewPostInputType

  field :post, Types::PostType
  field :errors, [String]

  def resolve(post:)
    uri = URI("http://127.0.0.1:3000/users/#{post[:user_id]}/posts")
    bearer_token = context[:request].headers['Authorization']&.split('Bearer ')&.last

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type'=>'application/json', 'Authorization'=>"Bearer #{bearer_token}"})
    request.body = {post: {title: post[:title], body: post[:body], category_id: post[:category_id], tags_ids: post[:tags_ids]}}.to_json
    res = http.request(request)
    data = JSON.parse(res.body)
    puts "data of errors is  #{data["errors"]}"

    if res.is_a?(Net::HTTPCreated)
      {
        post: data["post"],
        errors: []
      }
    else
      {
        post: nil,
        errors: data["errors"]
      }
    end
  end
end