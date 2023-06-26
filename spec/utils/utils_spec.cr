require "./spec_helper"

alias ProcessedTravelStop = NamedTuple(id: Int32, name: String, type: String, dimension: String)
describe "Test utils methods" do
    expanded_input = [
        {
            id: 2,
            name: "Abadango",
            type: "Cluster",
            dimension: "unknown",
            residents: [
                {
                    id: 6,
                    episode: [
                        {
                            id: 27
                        }
                    ]
                }
            ]
        },
        {
            id: 11,
            name: "Bepis 9",
            type: "Planet",
            dimension: "unknown",
            residents: [
                {
                    id: 35,
                    episode: [
                        {
                            id: 1
                        },
                        {
                            id: 11
                        },
                        {
                            id: 19
                        },
                        {
                            id: 25
                        }
                    ]
                }
            ]
        },
        {
            id: 19,
            name: "Gromflom Prime",
            type: "Planet",
            dimension: "Replacement Dimension",
            residents: [] of NamedTuple(id: Int32, episode: Array(NamedTuple(id: Int32)))
        }
    ]

    travel_plan = TravelPlan.new(id: 1, travel_stops: [2, 11, 19])

    it "should parse the locations to TravelStops" do
        parsed_locations = parse_locations_to_object([2])

        parsed_locations.should be_a(TravelStops)

        location = parsed_locations[0]

        location["id"].should eq 2
        location["name"].should eq "Abadango"
        location["type"].should eq "Cluster"
        location["dimension"].should eq "unknown"
        location["residents"].size.should eq 1
        location["residents"][0]["id"].should eq 6
        location["residents"][0]["episode"].size.should eq 1
        location["residents"][0]["episode"][0]["id"].should eq 27
    end

    it "should expand TravelStops" do
        expanded_travel_stops = expand_travel_stops([19,2,11], expanded_input.as(TravelStops))
        
        expanded_travel_stops.should be_a(TravelStops)
        expanded_travel_stops.size.should eq 3
        expanded_travel_stops[0]["id"].should eq 19
        expanded_travel_stops[1]["id"].should eq 2
        expanded_travel_stops[2]["id"].should eq 11
    end

    it "should optimize array of integers" do
        optimized_travel_stops = optimize_travel_stops(expanded_input.as(TravelStops))

        optimized_travel_stops.should be_a(Array(Int32))
        optimized_travel_stops.size.should eq 3
        optimized_travel_stops[0].should eq 19
        optimized_travel_stops[1].should eq 2
        optimized_travel_stops[2].should eq 11
    end

    it "should remove residents key of travel stops" do
        travel_stops_without_residents = remove_residents(expanded_input.as(TravelStops))

        travel_stops_without_residents.size.should eq 3
        travel_stops_without_residents[0].has_key?("residents").should be_falsey
        travel_stops_without_residents[1].has_key?("residents").should be_falsey
        travel_stops_without_residents[2].has_key?("residents").should be_falsey
    end

    it "should should process travel plan based on params expand=true and optimize=false" do
        params = {
            expand: "true",
            optimize: "false"
        }
        processed_travel_stops = process_travel_stops(travel_plan, params).as Array(ProcessedTravelStop)

        processed_travel_stops.size.should eq 3

        processed_travel_stops[0]["id"].to_s.to_i.should eq 2
        processed_travel_stops[0]["name"].should eq "Abadango"
        processed_travel_stops[0]["type"].should eq "Cluster"
        processed_travel_stops[0]["dimension"].should eq "unknown"
        
        processed_travel_stops[1]["id"].to_s.to_i.should eq 11
        processed_travel_stops[1]["name"].should eq "Bepis 9"
        processed_travel_stops[1]["type"].should eq "Planet"
        processed_travel_stops[1]["dimension"].should eq "unknown"

        processed_travel_stops[2]["id"].to_s.to_i.should eq 19
        processed_travel_stops[2]["name"].should eq "Gromflom Prime"
        processed_travel_stops[2]["type"].should eq "Planet"
        processed_travel_stops[2]["dimension"].should eq "Replacement Dimension"
    end

    it "should should process travel plan based on params expand=true and optimize=true" do
        params = {
            expand: "true",
            optimize: "true"
        }
        processed_travel_stops = process_travel_stops(travel_plan, params).as Array(ProcessedTravelStop)

        processed_travel_stops.size.should eq 3
        
        processed_travel_stops[0]["id"].to_s.to_i.should eq 19
        processed_travel_stops[0]["name"].should eq "Gromflom Prime"
        processed_travel_stops[0]["type"].should eq "Planet"
        processed_travel_stops[0]["dimension"].should eq "Replacement Dimension"

        processed_travel_stops[1]["id"].to_s.to_i.should eq 2
        processed_travel_stops[1]["name"].should eq "Abadango"
        processed_travel_stops[1]["type"].should eq "Cluster"
        processed_travel_stops[1]["dimension"].should eq "unknown"
        
        processed_travel_stops[2]["id"].to_s.to_i.should eq 11
        processed_travel_stops[2]["name"].should eq "Bepis 9"
        processed_travel_stops[2]["type"].should eq "Planet"
        processed_travel_stops[2]["dimension"].should eq "unknown"
    end

    it "should should process travel plan based on params expand=false and optimize=true" do
        params = {
            expand: "false",
            optimize: "true"
        }
        processed_travel_stops = process_travel_stops(travel_plan, params).as Array(Int32)

        processed_travel_stops.size.should eq 3
        
        processed_travel_stops[0].to_s.to_i.should eq 19
        processed_travel_stops[1].to_s.to_i.should eq 2
        processed_travel_stops[2].to_s.to_i.should eq 11
    end

    it "should should process travel plan based on params expand=false and optimize=false" do
        params = {
            expand: "false",
            optimize: "false"
        }
        processed_travel_stops = process_travel_stops(travel_plan, params).as Array(Int32)

        processed_travel_stops.size.should eq 3
        
        processed_travel_stops[0].to_s.to_i.should eq 2
        processed_travel_stops[1].to_s.to_i.should eq 11
        processed_travel_stops[2].to_s.to_i.should eq 19
    end
end