class Galaxy < ActiveRecord::Base
  has_many :quadrants, dependent: :destroy
end
