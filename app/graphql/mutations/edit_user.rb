class Mutations::EditUser < Mutations::BaseMutation
  argument :id, String
  argument :display_name, String
  argument :username, String
  argument :email, String
  argument :current_password, String, required: false
  argument :new_password, String, required: false
  argument :new_password_confirmation, String, required: false

  field :errors, [String], null: false

  def resolve(id:, display_name:, username:, email:, current_password:, new_password:, new_password_confirmation:)
    puts "context is #{context[:avatar]}"
    uri = URI("http://127.0.0.1:3000/users/#{id}")
    bearer_token = context[:request].headers["Authorization"]

    http = Net::HTTP.new(uri.host, uri.port)

    # Build the request
    request = Net::HTTP::Put::new(uri.path)
    request['Content-Type'] = 'multipart/form-data'
    request['Authorization'] = bearer_token

      form_data = [
    ['user[id]', id],
    ['user[display_name]', display_name],
    ['user[username]', username],
    ['user[email]', email],
    ['user[current_password]', current_password],
    ['user[password]', new_password],
    ['user[password_confirmation]', new_password_confirmation],
    ['user[avatar]', Multipart::Post::UploadIO.new(context[:avatar].tempfile, context[:avatar].content_type, context[:avatar].original_filename)]
  ]

    # Set the request body to the FormData
    # request.body = form_data
    request.set_form form_data, 'multipart/form-data'

    # Send the request
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

  #   uri = URI("http://127.0.0.1:3000/users/#{id}")
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   bearer_token = context[:request].headers["Authorization"]
  #   request = Net::HTTP::Put.new(uri.path, {'Content-Type'=>'application/json',"Authorization": bearer_token})
  #   if current_password.blank?
  #     request.body = {user:{id: id, display_name: display_name, username: username, email: email}}.to_json
  #   else
  #     request.body = {user:{id: id, display_name: display_name, username: username, email: email, current_password: current_password, password: new_password, password_confirmation: new_password_confirmation}}.to_json
  #   end
  #   res = http.request(request)

  #   if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
  #     {
  #       errors: []
  #     }
  #   else
  #     {
  #       errors: [res.body]
  #     }
  #   end
  # end
end