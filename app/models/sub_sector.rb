class SubSector < ActiveRecord::Base
  belongs_to :sector
  has_one :system, dependent: :destroy
end
