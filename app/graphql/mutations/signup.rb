require 'uri'
require 'net/http'

class Mutations::Signup < Mutations::BaseMutation
  argument :display_name, String, required: true
  argument :email, String , required: true
  argument :username, String , required: true
  argument :password, String , required: true
  argument :password_confirmation, String , required: true

  field :errors , [String], null: false

  def resolve(display_name:, email:, username:, password:, password_confirmation:)
    uri = URI("http://127.0.0.1:3000/users")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = {user:{display_name: display_name, username: username ,email: email,password: password,password_confirmation: password_confirmation}}.to_json
    res = http.request(request)
  
    if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
      {
        errors: []
      }
    else
      {
        errors: [res.body]
      }
    end
  end
end