json.array!(@systems) do |system|
  json.extract! system, :id, :sub_sector_id, :name
  json.url system_url(system, format: :json)
end
