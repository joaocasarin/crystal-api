class TravelPlan < Granite::Base
  connection pg
  table travel_plans

  column id : Int64, primary: true
  column travel_stops : Array(Int32)
  timestamps
end
