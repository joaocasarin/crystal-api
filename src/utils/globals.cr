module GlobalTypes
    alias TRAVEL_STOPS_TYPE = Array(NamedTuple(id: Int32, name: String, type: String, dimension: String, residents: Array(NamedTuple(id: Int32, episode: Array(NamedTuple(id: Int32))))))
end