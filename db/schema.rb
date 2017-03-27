# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170323153454) do

  create_table "galaxies", force: :cascade do |t|
    t.integer  "turn_number",    limit: 4
    t.integer  "turn_frequency", limit: 4
    t.string   "name",           limit: 255
    t.datetime "last_turn_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "moons", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "planet_id",      limit: 4
    t.float    "average_orbit",  limit: 24
    t.float    "eccentricity",   limit: 24
    t.float    "mass",           limit: 24
    t.float    "radius",         limit: 24
    t.float    "density",        limit: 24
    t.integer  "planet_type_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "surface_area",   limit: 24
  end

  create_table "ore_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "ores", force: :cascade do |t|
    t.integer  "depth",       limit: 4
    t.integer  "size",        limit: 4
    t.float    "strip_ratio", limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "planet_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "planets", force: :cascade do |t|
    t.integer  "system_id",        limit: 4
    t.string   "name",             limit: 255
    t.float    "average_orbit",    limit: 24
    t.float    "eccentricity",     limit: 24
    t.float    "mass",             limit: 24
    t.float    "radius",           limit: 24
    t.float    "density",          limit: 24
    t.integer  "planet_type_id",   limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "surface_area",     limit: 24
    t.integer  "parent_planet_id", limit: 4
    t.integer  "axial_tilt",       limit: 4
  end

  add_index "planets", ["parent_planet_id"], name: "index_planets_on_parent_planet_id", using: :btree

  create_table "quadrants", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "quadrant_x", limit: 4
    t.integer  "quadrant_y", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "galaxy_id",  limit: 4
  end

  create_table "regions", force: :cascade do |t|
    t.integer  "average_temperature",  limit: 4
    t.integer  "temperature_variance", limit: 4
    t.integer  "maximum_latitude",     limit: 4
    t.integer  "minimum_latitude",     limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "quadrant_id", limit: 4
    t.integer  "sector_x",    limit: 4
    t.integer  "sector_y",    limit: 4
  end

  create_table "stars", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "system_id",           limit: 4
    t.string   "luminosity",          limit: 255
    t.float    "mass",                limit: 24
    t.float    "diameter",            limit: 24
    t.float    "surface_temperature", limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "spectral_class",      limit: 255
  end

  create_table "sub_sectors", force: :cascade do |t|
    t.integer  "sector_id",   limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "subsector_x", limit: 4
    t.integer  "subsector_y", limit: 4
  end

  create_table "systems", force: :cascade do |t|
    t.integer  "sub_sector_id",                    limit: 4
    t.string   "name",                             limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "primary_star_id",                  limit: 4
    t.integer  "secondary_star_id",                limit: 4
    t.float    "binary_average_distance",          limit: 24
    t.float    "barycenter",                       limit: 24
    t.float    "primary_eccentricity",             limit: 24
    t.float    "secondary_eccentricity",           limit: 24
    t.float    "primary_max_distance",             limit: 24
    t.float    "secondary_max_distance",           limit: 24
    t.float    "primary_min_distance",             limit: 24
    t.float    "secondary_min_distance",           limit: 24
    t.float    "inner_orbit_limit",                limit: 24
    t.float    "outer_orbit_limit",                limit: 24
    t.float    "frost_line",                       limit: 24
    t.float    "habitable_zone_inner",             limit: 24
    t.float    "habitable_zone_outer",             limit: 24
    t.float    "forbidden_zone_inner",             limit: 24
    t.float    "forbidden_zone_outer",             limit: 24
    t.integer  "primary_subsystem_id",             limit: 4
    t.integer  "secondary_subsystem_id",           limit: 4
    t.float    "subsystem_average_distance",       limit: 24
    t.float    "subsystem_barycenter",             limit: 24
    t.float    "primary_subsystem_eccentricity",   limit: 24
    t.float    "secondary_subsystem_eccentricity", limit: 24
    t.float    "primary_subsystem_max_distance",   limit: 24
    t.float    "secondary_subsystem_max_distance", limit: 24
    t.float    "primary_subsystem_min_distance",   limit: 24
    t.float    "secondary_subsystem_min_distance", limit: 24
    t.integer  "parent_system_id",                 limit: 4
  end

  add_index "systems", ["parent_system_id"], name: "index_systems_on_parent_system_id", using: :btree

end
