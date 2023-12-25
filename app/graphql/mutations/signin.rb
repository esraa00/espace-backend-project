require 'uri'
require 'net/http'

class Mutations::Signin < Mutations::BaseMutation
  argument :user, Types::SignInInputType

  field :errors , [String], null: false
  field :bearer_token, String

  def resolve(user:)
    uri = URI("http://127.0.0.1:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user:{login: user["usernameOrEmail"], password: user["password"] }}.to_json
    res = http.request(request)
    response = context[:response]

    if res.is_a?(Net::HTTPSuccess)
      #TODO: Fix
      # bearer_token = res["Authorization"]
      # response.headers['Authorization'] = bearer_token
      {
        bearer_token: res["Authorization"],
        errors: [],
      }
    else
      {
        bearer_token: nil,
        errors: [res.body],
      }
    end
  end
end