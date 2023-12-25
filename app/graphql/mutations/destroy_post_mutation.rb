class Mutations::DestroyPostMutation < Mutations::BaseMutation
  argument :post , Types::DestroyPostInputType

  field :message, String
  field :errors, [String]

  def resolve(post:)
    uri = URI("http://127.0.0.1:3000/users/#{post[:user_id]}/posts/#{post[:id]}")
    bearer_token = context[:request].headers["Authorization"]&.split('Bearer ')&.last

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.path, 'Content-Type'=>'application/json', 'Authorization'=>"Bearer #{bearer_token}")
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