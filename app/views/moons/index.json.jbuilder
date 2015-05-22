json.array!(@moons) do |moon|
  json.extract! moon, :id, :name, :planet_id, :average_orbit, :eccentricity, :mass, :radius, :density, :planet_type_id
  json.url moon_url(moon, format: :json)
end
