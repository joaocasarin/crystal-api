class TravelPlanController < Amber::Controller::Base
  def index
    travel_plans = TravelPlan.all
    respond_with 200 do
      json travel_plans.to_json
    end
  end

  def show
    isIdInteger = params["id"].to_i?

    if isIdInteger
      if travel_plan = TravelPlan.find params["id"]
        respond_with 200 do
          json travel_plan.to_json
        end
      else
        results = {error: "Travel plan not found."}
        respond_with 404 do
          json results.to_json
        end
      end
    else
      results = {error: "Travel plan id must be an integer."}
      respond_with 400 do
        json results.to_json
      end
    end
  end

  def create
    isTravelStopsArrayOfIntegers = begin
      stops_string = travel_plan_params["travel_stops"].to_s
      stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
      !!stops_json
    rescue
      false
    end

    if isTravelStopsArrayOfIntegers
      travel_stops = JSON.parse(travel_plan_params["travel_stops"].not_nil!).as_a.map(&.as_i)
      travel_plan = TravelPlan.new(travel_stops: travel_stops)

      if travel_plan.valid? && travel_plan.save
        respond_with 201 do
          json travel_plan.to_json
        end
      else
        results = {error: "Travel plan could not be created."}
        respond_with 400 do
          json results.to_json
        end
      end
    else
      results = {error: "Travel stops must be an array of integers."}
      respond_with 400 do
        json results.to_json
      end
    end
  end

  def update
    isIdInteger = params["id"].to_i?
    
    if isIdInteger
      if travel_plan = TravelPlan.find(params["id"])
        isTravelStopsArrayOfIntegers = begin
          stops_string = travel_plan_params["travel_stops"].to_s
          stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
          !!stops_json
        rescue
          false
        end

        if isTravelStopsArrayOfIntegers
          travel_plan.travel_stops = JSON.parse(travel_plan_params["travel_stops"].not_nil!).as_a.map(&.as_i)
  
          if travel_plan.valid? && travel_plan.save
            respond_with 200 do
              json travel_plan.to_json
            end
          else
            results = {error: "Travel plan could not be updated."}
            respond_with 400 do
              json results.to_json
            end
          end
        else
          results = {error: "Travel stops must be an array of integers."}
          respond_with 400 do
            json results.to_json
          end
        end
      else
        results = {error: "Travel plan not found."}
        respond_with 404 do
          json results.to_json
        end
      end
    else
      results = {error: "Travel plan id must be an integer."}
      respond_with 400 do
        json results.to_json
      end
    end
  end

  def append
    isIdInteger = params["id"].to_i?

    if isIdInteger
      if travel_plan = TravelPlan.find(params["id"])
        isTravelStopsArrayOfIntegers = begin
          stops_string = new_travel_stops_params["new_travel_stops"].to_s
          stops_json = JSON.parse(stops_string).as_a.map(&.as_i) unless stops_string.empty?
          !!stops_json
        rescue
          false
        end

        if isTravelStopsArrayOfIntegers
          new_stops = JSON.parse(new_travel_stops_params["new_travel_stops"].not_nil!).as_a.map(&.as_i)
  
          travel_plan.travel_stops.each do |travel_stop|
            stop_string = travel_stop.to_s
            if new_travel_stops_params["new_travel_stops"].includes? stop_string
              new_stops.delete travel_stop
            end
          end
  
          if new_stops == [] of Int32
            return respond_with 304 do
              json ""
            end
          end

          travel_plan.travel_stops = travel_plan.travel_stops + new_stops

          if travel_plan.valid? && travel_plan.save
            respond_with 200 do
              json travel_plan.to_json
            end
          else
            results = {error: "Travel plan could not be updated."}
            respond_with 400 do
              json results.to_json
            end
          end
        else
          results = {error: "Travel stops must be an array of integers."}
          respond_with 400 do
            json results.to_json
          end
        end
      else
        results = {error: "Travel plan not found."}
        respond_with 404 do
          json results.to_json
        end
      end
    else
      results = {error: "Travel plan id must be an integer."}
      respond_with 400 do
        json results.to_json
      end
    end
  end

  def destroy
    isIdInteger = params["id"].to_i?

    if isIdInteger
      if travel_plan = TravelPlan.find params["id"]
        travel_plan.destroy
        respond_with 204 do
          json ""
        end
      else
        results = {error: "Travel plan not found."}
        respond_with 404 do
          json results.to_json
        end
      end
    else
      results = {error: "Travel plan id must be an integer."}
      respond_with 400 do
        json results.to_json
      end
    end
  end

  def travel_plan_params
    params.validation do
      required(:travel_stops, msg: nil, allow_blank: true)
    end
  end

  def new_travel_stops_params
    params.validation do
      required(:new_travel_stops, msg: nil, allow_blank: true)
    end
  end
end
