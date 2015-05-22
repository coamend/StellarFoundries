json.array!(@sub_sectors) do |sub_sector|
  json.extract! sub_sector, :id, :sector_id, :subsector_X, :subsector_Y
  json.url sub_sector_url(sub_sector, format: :json)
end
