class TravelPlanController < Amber::Controller::Base
  alias TRAVEL_STOPS_TYPE = Array(NamedTuple(id: Int32, name: String, type: String, dimension: String, residents: Array(NamedTuple(id: Int32, episode: Array(NamedTuple(id: Int32))))))

  #! MISSING handle expand and optimize
  def index
    travel_plans = TravelPlan.all
    respond_with 200 do
      body = travel_plans.map do |travel_plan|
        {
          id: travel_plan.id.not_nil!,
          travel_stops: travel_plan.travel_stops
        }
      end.to_json
      json body
    end
  end

  #* DONE
  def show
    is_id_integer = params["id"].to_i?
    
    if is_id_integer #* DONE ID is valid integer
      if travel_plan = TravelPlan.find params["id"] #* DONE ID found
        respond_with 200 do
          body = {
            id: travel_plan.id.not_nil!,
            travel_stops: process_travel_stops(travel_plan, params)
          }.to_json
          json body
        end
      else #* DONE ID not found
        respond_with 404 do
          body = {error: "Travel plan not found."}.to_json
          json body
        end
      end
    else #* DONE ID is not integer
      respond_with 400 do
        body = {error: "Travel plan id must be an integer."}.to_json
        json body
      end
    end
  end

  #* DONE
  def create
    is_travel_stops_array_of_integers = begin #* DONE check if stops are array of integers
      stops_string = travel_plan_params["travel_stops"].to_s
      stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
      !!stops_json
    rescue
      false
    end

    if is_travel_stops_array_of_integers #* DONE stops are array of integers
      travel_stops = JSON.parse(travel_plan_params["travel_stops"].not_nil!).as_a.map(&.as_i)
      travel_plan = TravelPlan.new(travel_stops: travel_stops)

      if travel_plan.valid? && travel_plan.save #* DONE travel plan is valid and saved
        respond_with 201 do
          body = {
            id: travel_plan.id.not_nil!,
            travel_stops: travel_plan.travel_stops
          }.to_json
          json body
        end
      else #* DONE travel plan is not valid or could not be saved
        body = {error: "Travel plan could not be created."}.to_json
        respond_with 400 do
          json body
        end
      end
    else #* Done stops are not array of integers
      body = {error: "Travel stops must be an array of integers."}.to_json
      respond_with 400 do
        json body
      end
    end
  end

  #* DONE
  def update
    is_id_integer = params["id"].to_i?
    
    if is_id_integer #* DONE ID is valid integer
      if travel_plan = TravelPlan.find(params["id"]) #* DONE ID found
        is_travel_stops_array_of_integers = begin #* DONE check if stops are array of integers
          stops_string = travel_plan_params["travel_stops"].to_s
          stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
          !!stops_json
        rescue
          false
        end

        if is_travel_stops_array_of_integers #* DONE stops are array of integers
          travel_plan.travel_stops = JSON.parse(travel_plan_params["travel_stops"].not_nil!).as_a.map(&.as_i)
  
          if travel_plan.valid? && travel_plan.save #* DONE travel plan is valid and saved
            respond_with 200 do
              body = {
                id: travel_plan.id.not_nil!,
                travel_stops: travel_plan.travel_stops
              }.to_json
              json body
            end
          else #* DONE travel plan is not valid or could not be saved
            body = {error: "Travel plan could not be updated."}.to_json
            respond_with 400 do
              json body
            end
          end
        else #* DONE stops are not array of integers
          body = {error: "Travel stops must be an array of integers."}.to_json
          respond_with 400 do
            json body
          end
        end
      else #* DONE ID not found
        body = {error: "Travel plan not found."}.to_json
        respond_with 404 do
          json body
        end
      end
    else #* DONE ID is not integer
      body = {error: "Travel plan id must be an integer."}.to_json
      respond_with 400 do
        json body
      end
    end
  end

  #* DONE
  def append
    is_id_integer = params["id"].to_i?

    if is_id_integer #* DONE ID is valid integer
      if travel_plan = TravelPlan.find(params["id"]) #* DONE ID found
        isTravelStopsArrayOfIntegers = begin #* DONE check if stops are array of integers
          stops_string = travel_plan_params["travel_stops"].to_s
          stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
          !!stops_json
        rescue
          false
        end

        if isTravelStopsArrayOfIntegers #* DONE stops are array of integers
          new_stops = JSON.parse(travel_plan_params["travel_stops"].not_nil!).as_a.map(&.as_i)
  
          travel_plan.travel_stops.each do |travel_stop|
            stop_string = travel_stop.to_s
            if travel_plan_params["travel_stops"].includes? stop_string
              new_stops.delete travel_stop
            end
          end
  
          if new_stops == [] of Int32
            return respond_with 304 do
              json ""
            end
          end

          travel_plan.travel_stops = travel_plan.travel_stops + new_stops

          if travel_plan.valid? && travel_plan.save #* DONE travel plan is valid and saved
            respond_with 200 do
              body = {
                id: travel_plan.id.not_nil!,
                travel_stops: travel_plan.travel_stops
              }.to_json
              json body
            end
          else #* DONE travel plan is not valid or could not be saved
            body = {error: "Travel plan could not be updated."}.to_json
            respond_with 400 do
              json body
            end
          end
        else #* DONE stops are not array of integers
          body = {error: "Travel stops must be an array of integers."}.to_json
          respond_with 400 do
            json body
          end
        end
      else #* DONE ID not found
        body = {error: "Travel plan not found."}.to_json
        respond_with 404 do
          json body
        end
      end
    else #* DONE ID is not integer
      body = {error: "Travel plan id must be an integer."}.to_json
      respond_with 400 do
        json body
      end
    end
  end

  #* DONE
  def destroy
    is_id_integer = params["id"].to_i?

    if is_id_integer #* DONE ID is valid integer
      if travel_plan = TravelPlan.find params["id"] #* DONE ID found
        travel_plan.destroy
        respond_with 204 do
          json ""
        end
      else #* DONE ID not found
        body = {error: "Travel plan not found."}.to_json
        respond_with 404 do
          json body
        end
      end
    else #* DONE ID is not integer
      body = {error: "Travel plan id must be an integer."}.to_json
      respond_with 400 do
        json body
      end
    end
  end

  #* DONE validate request body to have travel_stops
  def travel_plan_params
    params.validation do
      required(:travel_stops, msg: nil, allow_blank: true)
    end
  end

  #! MISSING get from database if exists
  private def get_locations(ids : Array(Int32)) : TRAVEL_STOPS_TYPE
    api_response = REMClient.get_locations(ids)

    return TRAVEL_STOPS_TYPE.new if api_response.status_code != 200

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

    return locations.as(TRAVEL_STOPS_TYPE)
  end

  #* DONE
  private def expand_travel_stops(travel_stops : Array(Int32), locations : TRAVEL_STOPS_TYPE) : TRAVEL_STOPS_TYPE
    new_travel_stops = TRAVEL_STOPS_TYPE.new

    travel_stops.each do |travel_stop|
      locations.each do |location|
        if location["id"] == travel_stop
          new_travel_stops << location
        end
      end
    end

    return new_travel_stops
  end

  #* DONE
  private def optimize_travel_stops(locations : TRAVEL_STOPS_TYPE) : Array(Int32)
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

  #* DONE check if any of expand or optimize was passed as query parameter
  private def is_any_of_expand_or_optimize?(params)
    return params["expand"]? || params["optimize"]?
  end

  #* DONE remove residents key from expanded travel stops
  private def remove_residents(travel_stops : TRAVEL_STOPS_TYPE)
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
  private def process_travel_stops(travel_plan, params)
    if is_any_of_expand_or_optimize?(params)
      if params["expand"]? && params["optimize"]?
        if params["expand"] == "true" && params["optimize"] == "true"
          locations = get_locations(travel_plan.travel_stops)
          expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
          optimized_travel_stops = optimize_travel_stops(expanded_travel_stops)
          expanded_and_optimized_travel_stops = expand_travel_stops(optimized_travel_stops, locations)
          return remove_residents(expanded_and_optimized_travel_stops)
        elsif params["expand"] == "true" && params["optimize"] != "true"
          locations = get_locations(travel_plan.travel_stops)
          expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
          return remove_residents(expanded_travel_stops)
        elsif params["expand"] != "true" && params["optimize"] == "true"
          locations = get_locations(travel_plan.travel_stops)
          expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
          optimized_travel_stops = optimize_travel_stops(expanded_travel_stops)
          return optimized_travel_stops
        else
          return travel_plan.travel_stops
        end
      elsif params["expand"]?
        if params["expand"] == "true"
          locations = get_locations(travel_plan.travel_stops)
          expanded_travel_stops = expand_travel_stops(travel_plan.travel_stops, locations)
          return remove_residents(expanded_travel_stops)
        else
          return travel_plan.travel_stops
        end
      elsif params["optimize"]?
        if params["optimize"] == "true"
          locations = get_locations(travel_plan.travel_stops)
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
