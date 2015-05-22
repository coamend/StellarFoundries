json.array!(@sectors) do |sector|
  json.extract! sector, :id, :universe_id, :sectorX, :sectorY
  json.url sector_url(sector, format: :json)
end
