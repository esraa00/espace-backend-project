require 'uri'
require 'net/http'

class Mutations::Signin < Mutations::BaseMutation
  argument :usernameOrEmail, String, required: true
  argument :password, String, required: true

  field :errors , [String], null: false

  def resolve(usernameOrEmail:, password:)
    uri = URI("http://127.0.0.1:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user:{login: usernameOrEmail, password: password}}.to_json
    res = http.request(request)
    puts "body is #{res.body}"
    puts "code is #{res.code}"
    puts "res is #{res}"

    if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
      set_cookie_header = res['Set-Cookie']
      puts "Set-Cookie header is: #{set_cookie_header}"
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