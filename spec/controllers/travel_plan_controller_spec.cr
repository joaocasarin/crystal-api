require "./spec_helper"

def travel_plan_hash
  {"travel_stops" => "Fake"}
end

def travel_plan_params
  params = [] of String
  params << "travel_stops=#{travel_plan_hash["travel_stops"]}"
  params.join("&")
end

def create_travel_plan
  model = TravelPlan.new(travel_plan_hash)
  model.save
  model
end

class TravelPlanControllerTest < GarnetSpec::SystemTest
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
    end
    @handler.prepare_pipelines
  end
end

describe TravelPlanControllerTest do
  subject = TravelPlanControllerTest.new

  it "renders travel_plan index json" do
    TravelPlan.clear
    model = create_travel_plan
    response = subject.get "/travel_plans"

    response.status_code.should eq(200)
    response.body.should contain("Fake")
  end

  it "renders travel_plan show json" do
    TravelPlan.clear
    model = create_travel_plan
    location = "/travel_plans/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Fake")
  end

  it "creates a travel_plan" do
    TravelPlan.clear
    response = subject.post "/travel_plans", body: travel_plan_params

    response.status_code.should eq(201)
    response.body.should contain "Fake"
  end

  it "updates a travel_plan" do
    TravelPlan.clear
    model = create_travel_plan
    response = subject.patch "/travel_plans/#{model.id}", body: travel_plan_params

    response.status_code.should eq(200)
    response.body.should contain "Fake"
  end

  it "deletes a travel_plan" do
    TravelPlan.clear
    model = create_travel_plan
    response = subject.delete "/travel_plans/#{model.id}"

    response.status_code.should eq(204)
  end
end
