# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PlanetType.create(name: 'Gas Giant')
PlanetType.create(name: 'Gas Dwarf')
PlanetType.create(name: 'Puffy Giant')
PlanetType.create(name: 'Sub Earth')
PlanetType.create(name: 'Super Earth')
PlanetType.create(name: 'Asteroid Belt')
PlanetType.create(name: 'Brown Dwarf')
PlanetType.create(name: 'Ring')
PlanetType.create(name: 'Moon')

OreType.create(name: 'Noble Gas')
OreType.create(name: 'Polyatomic Nonmetal')
OreType.create(name: 'Diatomic Nonmetal')
OreType.create(name: 'Metalloid')
OreType.create(name: 'Alkaline Earth Metal')
OreType.create(name: 'Alkali Metal')
OreType.create(name: 'Base Metal')
OreType.create(name: 'Noble Metal')
OreType.create(name: 'Refractory Metal')
OreType.create(name: 'Rare Earth Element')
OreType.create(name: 'Actinide')