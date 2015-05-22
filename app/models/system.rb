class System < ActiveRecord::Base
  belongs_to :sub_sector

  has_one :primary_star, class_name: "Star",
                          foreign_key: "id",
                          primary_key: "primary_star_id",
                          dependent: :destroy
  has_one :secondary_star, class_name: "Star",
                          foreign_key: "id",
                          primary_key: "secondary_star_id",
                          dependent: :destroy

  belongs_to :parent_system, class_name: "System",
                              foreign_key: "id",
                              primary_key: "parent_system_id"
  has_one :primary_subsystem, class_name: "System",
                              foreign_key: "id",
                              primary_key: "primary_subsystem_id",
                              dependent: :destroy
  has_one :secondary_subsystem, class_name: "System",
                                foreign_key: "id",
                                primary_key: "secondary_subsystem_id",
                                dependent: :destroy

  has_many :planets, dependent: :destroy
end
