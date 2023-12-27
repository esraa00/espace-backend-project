class Mutations::EditUserMutation < Mutations::BaseMutation
  argument :user, Types::EditUserInputType

  field :errors, [String], null: false

  def resolve(user:)
    uri = URI("http://127.0.0.1:3000/users/#{user[:id]}")
    bearer_token = context[:request].headers["Authorization"]&.split('Bearer ')&.last

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path, {"Content-Type" => "multipart/form-data", "Authorization" => "Bearer #{bearer_token}" })
    form_data = {
      "user[id]" => user[:id],
      "user[display_name]" => user[:display_name],
      "user[username]" => user[:username],
      "user[email]" => user[:email]
    }
    if user[:new_password].present?
      form_data["user[password]"] = user[:new_password]
      form_data["user[current_password]"] = user[:current_password]
      form_data["user[password_confirmation]"] = user[:new_password_confirmation]
    end
    if !context[:avatar].nil? && context[:avatar] != "null"
      form_data["user[avatar]"] = Multipart::Post::UploadIO.new(context[:avatar].tempfile, context[:avatar].content_type, context[:avatar].original_filename)
    end
    puts "final form_data is #{form_data}"
      #TODO: why this is not working?(nested objects)
    request.set_form form_data, 'multipart/form-data'
    res = http.request(request)

    if res.is_a?(Net::HTTPSuccess)
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