json.array!(@planets) do |planet|
  json.extract! planet, :id, :system_id, :name, :average_orbit, :eccentricity, :mass, :radius, :density, :planet_type_id
  json.url planet_url(planet, format: :json)
end
