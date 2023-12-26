require 'uri'
require 'net/http'

class Mutations::SigninMutation < Mutations::BaseMutation
  argument :user, Types::SignInInputType

  field :errors , [String], null: false
  field :bearer_token, String

  def resolve(user:)
    uri = URI("http://127.0.0.1:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user: {login: user[:usernameOrEmail], password: user[:password] }}.to_json
    res = http.request(request)
    data = JSON.parse(res.body)

    if res.is_a?(Net::HTTPSuccess)
      {
        bearer_token: res["Authorization"],
        errors: [],
      }
    else
      {
        bearer_token: nil,
        errors: [data["error"]],
      }
    end
  end
end