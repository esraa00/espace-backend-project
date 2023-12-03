class Mutations::Login < Mutations::BaseMutation
  argument :email, String, required: false
  argument :username, String, required: false
  validates required: { one_of: [:username, :email] }
  argument :password, String, required: true

  field :errors , [String], null: false

  def resolve(email: nil, username: nil, password:)
    uri = URI("http://localhost:3000/users/sign_in")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type'=>'application/json')
    if email.present?
      request.body = {user:{email: email, password: password}}.to_json
    else
      request.body = {user:{username: username, password: password}}.to_json
    end
    res = http.request(request)
    puts "code is #{res.code}"

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