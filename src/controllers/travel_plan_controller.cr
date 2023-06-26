class TravelPlanController < Amber::Controller::Base
  #* DONE GET /travel_plans
  def index
    travel_plans = TravelPlan.all
    respond_with 200 do
      body = travel_plans.map do |travel_plan|
        {
          id: travel_plan.id.not_nil!,
          travel_stops: process_travel_stops(travel_plan, params)
        }
      end.to_json
      json body
    end
  end

  #* DONE GET /travel_plans/:id
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

  #* DONE POST /travel_plans
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

  #* DONE PUT /travel_plans/:id
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

  #* DONE PATCH /travel_plans/:id
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

  #* DONE DELETE /travel_plans/:id
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
end
