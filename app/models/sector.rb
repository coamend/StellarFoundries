class Sector < ActiveRecord::Base
  belongs_to :quadrant
  has_many :sub_sectors, dependent: :destroy
end
