require "./spec_helper"

describe "Get locations from Rick and Morty API" do
    it "should return a list of locations" do
        response = REMClient.get_locations([2])
        response.status_code.should eq(200)

        body = JSON.parse(response.body)

        body["data"]["locationsByIds"].should_not be_nil
        locations = body["data"]["locationsByIds"]
        locations.size.should eq(1)
    end
end