json.array!(@planet_types) do |planet_type|
  json.extract! planet_type, :id, :name
  json.url planet_type_url(planet_type, format: :json)
end
