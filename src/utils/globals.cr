module GlobalTypes
    alias Residents = Array(NamedTuple(id: Int32, episode: Array(NamedTuple(id: Int32))))
    alias TravelStop = NamedTuple(id: Int32, name: String, type: String, dimension: String, residents: Residents)
    alias TravelStops = Array(TravelStop)
end