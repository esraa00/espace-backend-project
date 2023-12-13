Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:5173', '127.0.0.1:5173'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :options], credentials: true, expose: %w(Authorization content-length)
  end
end
