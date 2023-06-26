module REMClient
  @@url = URI.parse("https://rickandmortyapi.com")
  @@client = HTTP::Client.new(@@url)

  QUERY = %{
    query LocationsByIds($ids: [ID!]!) {
      locationsByIds(ids: $ids) {
        id
        name
        type
        dimension
        residents {
          episode {
            id
          }
          id
        }
      }
    }
  }

  private def self.client
    @@client
  end

  def self.get_locations(ids : Array(Int32))
    query = QUERY
    headers = HTTP::Headers{"Content-Type" => "application/json"}
    body = {
      query:         query,
      operationName: "LocationsByIds",
      variables:     {
        ids: ids
      },
    }.to_json

    response = client.post("/graphql", headers, body)
    return response
  end
end
