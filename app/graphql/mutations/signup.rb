require 'uri'
require 'net/http'

class Mutations::Signup < Mutations::BaseMutation
  argument :user, Types::SignUpInputType

  field :errors , [String], null: false
  field :user, Types::UserType

  def resolve(user:)
    uri = URI("http://127.0.0.1:3000/users")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = {user: user }.to_json
    res = http.request(request)
    data = JSON.parse(res.body)
    puts "data is #{data}"
    #TODO: fix, send user + solve the error 
    if res.is_a?(Net::HTTPSuccess)
      {
        errors: []
      }
    else
      {
        errors: [data]
      }
    end
  end
end