class Quadrant < ActiveRecord::Base
  belongs_to :galaxy
  has_many :sectors, dependent: :destroy
end
