-- +micrate Up
CREATE TABLE travel_plans (
  id BIGSERIAL PRIMARY KEY,
  travel_stops INTEGER[] NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS travel_plans;
