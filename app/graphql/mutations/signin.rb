require 'uri'
require 'net/http'

class Mutations::Signin < Mutations::BaseMutation
  argument :usernameOrEmail, String, required: true
  argument :password, String, required: true
  argument :remember_me, Boolean, required: false

  field :errors , [String], null: false

  def resolve(usernameOrEmail:, password:)
    uri = URI("http://127.0.0.1:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user:{login: usernameOrEmail, password: password, remember_me: true}}.to_json
    res = http.request(request)
    response = context[:response]

    if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
      bearer_token = res["Authorization"]
      response.headers['Authorization'] = bearer_token
      {
        errors: [],
      }
    else
      {
        errors: [res.body],
      }
    end
  end
end