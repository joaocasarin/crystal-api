module Utils
    #* DONE check if any of expand or optimize was passed as query parameter
    def is_any_of_expand_or_optimize?(params)
        return params["expand"]? || params["optimize"]?
    end

    #! MISSING get from database if exists
    def parse_locations_to_object(ids : Array(Int32)) : TravelStops
        api_response = REMClient.get_locations(ids)

        return TravelStops.new if api_response.status_code != 200

        parsed_body = JSON.parse(api_response.body)
        locationsByIds = parsed_body["data"]["locationsByIds"].to_json
        locations = JSON.parse(locationsByIds).as_a.map do |location|
        {
            id: location["id"].to_s.to_i,
            name: location["name"].to_s,
            type: location["type"].to_s,
            dimension: location["dimension"].to_s,
            residents: location["residents"].as_a.map do |resident|
            {
                id: resident["id"].to_s.to_i,
                episode: resident["episode"].as_a.map { |ep| { id: ep["id"].to_s.to_i } }
            }
            end
        }
        end

        return locations.as(TravelStops)
    end

    #* DONE expand travel stops to include location details
    def expand_travel_stops(travel_stops : Array(Int32), locations : TravelStops) : TravelStops
        new_travel_stops = TravelStops.new

        travel_stops.each do |travel_stop|
            locations.each do |location|
                if location["id"] == travel_stop
                new_travel_stops << location
                end
            end
        end

        return new_travel_stops
    end

    #* DONE optimize travel stops based on popularity
    def optimize_travel_stops(locations : TravelStops) : Array(Int32)
        # Calculate popularity of each location
        location_popularity = Hash(Int32, Int32).new
        locations.each do |location|
        popularity = location["residents"].reduce(0) { |total, resident| total + resident["episode"].size }
        location_popularity[location["id"]] = popularity
        end

        # Calculate popularity of each dimension
        dimension_popularity = Hash(String, Float64).new
        dimensions = locations.map { |location| location["dimension"] }.uniq
        dimensions.each do |dimension|
        popularity = locations
            .select { |location| location["dimension"] == dimension }
            .map { |location| location_popularity[location["id"]] }
            .reduce(0.0) { |sum, value| sum + value }
        dimension_popularity[dimension] = popularity / locations.count { |location| location["dimension"] == dimension }
        end

        # Sort locations by popularity in descending order and then by name alphabetically within each dimension
        sorted_locations = locations.sort do |a, b|
        a_dimension_popularity = dimension_popularity[a["dimension"]]
        b_dimension_popularity = dimension_popularity[b["dimension"]]
        
        if a_dimension_popularity == b_dimension_popularity
            a_location_popularity = location_popularity[a["id"]]
            b_location_popularity = location_popularity[b["id"]]
        
            if a_location_popularity == b_location_popularity
            a["name"] <=> b["name"] # Sort alphabetically
            else
            a_location_popularity <=> b_location_popularity # Sort by ascending popularity
            end
        else
            a_dimension_popularity <=> b_dimension_popularity # Sort by ascending dimension popularity
        end
        end
        
        sorted_location_ids = sorted_locations.map { |location| location["id"] }

        return sorted_location_ids
    end

    #* DONE remove residents key from expanded travel stops
    def remove_residents(travel_stops : TravelStops)
        return travel_stops.map do |travel_stop|
        {
            id: travel_stop["id"],
            name: travel_stop["name"],
            type: travel_stop["type"],
            dimension: travel_stop["dimension"]
        }
        end
    end

    #* DONE process travel stops based on query parameters
    def process_travel_stops(travel_plan, params)
        if is_any_of_expand_or_optimize?(params)
        if params["expand"]? && params["optimize"]?
            if params["expand"] == "true" && params["optimize"] == "true"
            locations = parse_locations_to_object(travel_plan.travel_stops)
            expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
            optimized_travel_stops = optimize_travel_stops(expanded_travel_stops)
            expanded_and_optimized_travel_stops = expand_travel_stops(optimized_travel_stops, locations)
            return remove_residents(expanded_and_optimized_travel_stops)
            elsif params["expand"] == "true" && params["optimize"] != "true"
            locations = parse_locations_to_object(travel_plan.travel_stops)
            expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
            return remove_residents(expanded_travel_stops)
            elsif params["expand"] != "true" && params["optimize"] == "true"
            locations = parse_locations_to_object(travel_plan.travel_stops)
            expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
            optimized_travel_stops = optimize_travel_stops(expanded_travel_stops)
            return optimized_travel_stops
            else
            return travel_plan.travel_stops
            end
        elsif params["expand"]?
            if params["expand"] == "true"
            locations = parse_locations_to_object(travel_plan.travel_stops)
            expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
            return remove_residents(expanded_travel_stops)
            else
            return travel_plan.travel_stops
            end
        elsif params["optimize"]?
            if params["optimize"] == "true"
            locations = parse_locations_to_object(travel_plan.travel_stops)
            expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
            optimized_travel_stops = optimize_travel_stops(expanded_travel_stops)
            return optimized_travel_stops
            else
            return travel_plan.travel_stops
            end
        else
            return travel_plan.travel_stops
        end
        else
        return travel_plan.travel_stops
        end
    end
end
