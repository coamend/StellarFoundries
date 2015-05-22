json.array!(@quadrants) do |quadrant|
  json.extract! quadrant, :id, :universe_id, :name, :quadrant_x, :quadrant_y
  json.url quadrant_url(quadrant, format: :json)
end
