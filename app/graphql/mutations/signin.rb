require 'uri'
require 'net/http'

class Mutations::Signin < Mutations::BaseMutation
  argument :usernameOrEmail, String, required: true
  argument :password, String, required: true

  field :errors , [String], null: false
  field :bearer_token, String

  def resolve(usernameOrEmail:, password:)
    uri = URI("http://127.0.0.1:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user:{login: usernameOrEmail, password: password}}.to_json
    res = http.request(request)

    if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
      bearer_token = res["Authorization"]
      {
        errors: [],
        bearer_token: bearer_token
      }
    else
      {
        errors: [res.body],
        bearer_token: nil
      }
    end
  end
end