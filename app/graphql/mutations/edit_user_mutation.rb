class Mutations::EditUserMutation < Mutations::BaseMutation
  argument :display_name
  argument :username
  argument :email
  argument :current_password
  argument :new_password
  argument :new_password_confirmation

  field :errors, [String], null: false

  def resolve(display_name:, username:, email:, current_password:, new_password:, new_password_confirmation:)
    uri = URI("http://127.0.0.1:3000/users")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path, 'Content-Type'=>'application/json')
    request.body = {user:{display_name: display_name, username: username, email: email, current_password: current_password, new_password: new_password, new_password_confirmation: new_password_confirmation}}.to_json
    res = http.request(request)
    puts "body is #{res.body}"
    puts "code is #{res.code}"
    puts "res is #{res}"

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