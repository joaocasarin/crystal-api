# Travel Plans API

The Travel Plans API allows users to create travel plans through different locations and dimensions of the Rick and Morty show. Users can provide a list of locations and retrieve them later. The API supports options to expand the response with detailed location information and optimize the travel plan based on popularity.

## Installation

1. Install Crystal language by following the instructions for your operating system as available on [Crystal website](https://crystal-lang.org/install/). (e.g., macOS, Linux, or Windows with WSL) 
2. Install Docker and Docker Compose.
3. Clone the repository and navigate to the project directory.

## Getting Started

To launch the API and database, run the following command `docker compose up -d`.

This will start the PostgreSQL database on port 5432 and the application on port 3000.

Alternatively, if you have the database running locally or in another container, follow these steps:

1. Install the project dependencies: `shards install`
2. Change the `db` hostname in the variable `database_url` in the file `config/environments/development.yml` to `localhost` or the IP address of the database container.
3. Run migrations: `amber db migrate`
4. Run the application: `amber watch`

The application will be running on `http://localhost:3000` and will watch for any changes in the project files.

# Postman
To test the API using Postman, import the file `HTTP.postman_collection-2.json` or `HTTP.postman_collection-2.1.json` into Postman.
After importing that, you will be able to make HTTP requests to the API once that is already up and running with the database.

## Libraries

The Travel Plans API is built using the following technologies:

- Framework: Amber
- ORM: Granite
- Database: PostgreSQL


## Endpoints

### Get all travel plans

- `GET /travel_plans`
- `GET /travel_plans?expand=true`
- `GET /travel_plans?optimize=true`
- `GET /travel_plans?expand=true&optimize=true`

### Get travel plan by ID

- `GET /travel_plans/:id`
- `GET /travel_plans/:id?expand=true`
- `GET /travel_plans/:id?optimize=true`
- `GET /travel_plans/:id?expand=true&optimize=true`

### Create travel plan

- `POST /travel_plans`

### Change the list of locations in a travel plan

- `PUT /travel_plans/:id`

### Add one or more locations to a travel plan

- `PATCH /travel_plans/:id`

### Delete a travel plan

- `DELETE /travel_plans/:id`

## Request and Response Format

### Get all travel plans
* Request:
    * Method: `GET`
    * Path: `/travel_plans`
* Response without `expand`:
```json
[
    {
        "id": 1,
        "travel_stops": [1,2,3]
    }
]
```
* Response with `expand`:
```json
[
    {
        "id": 1,
        "travel_stops": [
            {
                "id": 1,
                "name": "Earth (C-137)",
                "type": "Planet",
                "dimension": "Dimension C-137"
            },
            {
                "id": 2,
                "name": "Abadango",
                "type": "Cluster",
                "dimension": "unknown"
            },
            {
                "id": 3,
                "name": "Citadel of Ricks",
                "type": "Space station",
                "dimension": "unknown"
            }
        ]
    }
]
```

### Get travel plan by ID
* Request:
    * Method: `GET`
    * Path: `/travel_plans/:id`
* Standard response:
```json
{
    "id": 1,
    "travel_stops": [2,7,9,11,19]
}
```
* Response with `optimize`:
```json
{
    "id": 1,
    "travel_stops": [19,9,2,11,7]
}
```
* Response with `expand` and `optimize`:
```json
{
    "id": 2,
    "travel_stops": [
        {
            "id": 19,
            "name": "Gromflom Prime",
            "type": "Planet",
            "dimension": "Replacement Dimension"
        },
        {
            "id": 9,
            "name": "Purge Planet",
            "type": "Planet",
            "dimension": "Replacement Dimension"
        },
        {
            "id": 2,
            "name": "Abadango",
            "type": "Cluster",
            "dimension": "unknown"
        },
        {
            "id": 11,
            "name": "Bepis 9",
            "type": "Planet",
            "dimension": "unknown"
        },
        {
            "id": 7,
            "name": "Immortality Field Resort",
            "type": "Resort",
            "dimension": "unknown"
        }
    ]
}
```

### Create travel plan
* Request:
    * Method: `POST`
    * Path: `/travel_plans`
    * Body:
    ```json
    {
        "travel_stops": [1,2,3]
    }
    ```
* Response:
```json
{
    "id": 1,
    "travel_stops": [1,2,3]
}
```

### Change the list of locations in a travel plan
* Request:
    * Method: `PUT`
    * Path: `/travel_plans/:id`
    * Body:
    ```json
    {
        "travel_stops": [4,5,6]
    }
    ```
* Response:
```json
{
    "id": 1,
    "travel_stops": [4,5,6]
}
```

### Add one or more locations to a travel plan
* Request:
    * Method: `PATCH`
    * Path: `/travel_plans/:id`
    * Body:
    ```json
    {
        "travel_stops": [7,8]
    }
    ```
* Response:
```json
{
    "id": 1,
    "travel_stops": [4,5,6,7,8]
}
```

### Delete a travel plan
* Request:
    * Method: `DELETE`
    * Path: `/travel_plans/:id`
* Response with code `204 No Content`

## Credits
- João Vitor Casarin
