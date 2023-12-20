class Mutations::EditPostMutation < Mutations::BaseMutation
  argument :post , Types::EditPostInputType

  field :message, String
  field :errors, [String]

  def resolve(post:)
    uri = URI("http://127.0.0.1:3000/users/#{post[:user_id]}/posts/#{post[:id]}")
    bearer_token = context[:request].headers["Authorization"]&.split('Bearer ')&.last

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path, 'Content-Type'=>'application/json', 'Authorization'=>"Bearer #{bearer_token}")
    request.body = {post: {id: post[:id], user_id: post[:user_id], title: post[:title], body: post[:body], category_id: post[:category_id], tags_ids: post[:tags_ids]}}.to_json
    res = http.request(request)
    if res.body.present? 
      data = JSON.parse(res.body) 
      {
        message: data["message"],
        errors: data["errors"],
      }
    end
  end
end