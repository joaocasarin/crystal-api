Amber::Server.configure do
  pipeline :web do
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
  end

  pipeline :api do
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new
  end

  pipeline :static do
  end

  routes :web do
  end

  routes :api do
    resources "/travel_plans", TravelPlanController, except: [:new, :edit, :update, :append]
    put "/travel_plans/:id", TravelPlanController, :update
    patch "/travel_plans/:id", TravelPlanController, :append
  end

  routes :static do
  end
end
