module GlobalTypes
    alias Episode = Array(NamedTuple(id: Int32))
    alias Residents = Array(NamedTuple(id: Int32, episode: Episode))
    alias TravelStop = NamedTuple(id: Int32, name: String, type: String, dimension: String, residents: Residents)
    alias TravelStops = Array(TravelStop)
end