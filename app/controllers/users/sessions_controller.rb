# return response into json
# check if the errors is sent as json and display them to the user
# modifications for devise to work with api without view

class Users::SessionsController < Devise::SessionsController
  respond_to :json
end