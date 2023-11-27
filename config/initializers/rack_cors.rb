Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/inns',
             headers: :any,
             methods: %i[get]
    resource '/rooms',
             headers: :any,
             methods: %i[get]
    resource '/reservation',
             headers: :any,
             methods: %i[get post]
  end
end
