json.array!(@galaxies) do |galaxy|
  json.extract! galaxy, :id, :turn_number, :turn_frequency, :name, :last_turn_at
  json.url galaxy_url(galaxy, format: :json)
end
