json.array!(@stars) do |star|
  json.extract! star, :id, :name, :system_id, :luminosity, :mass, :diameter, :surface_temperature
  json.url star_url(star, format: :json)
end
