-- Spawns random ships at the center of designated zones. I use it for civilian ships

local ship_names = {'Ziv_Naval-5', 'Ziv_Naval-4', 'Ziv_Naval-3', 'Ziv_Naval-2', 'Ziv_Naval-1'}
local zone_name_prefix = "shipSpawn-" -- name of your trigger zone. You must add a number, starting with 1 at the end
local zone_count = 40 -- will be made to 'shipSpawn-1', 'shipSpawn-3'... etc. 
local minnimum_ships = 20
local maximum_ships = 35

local zone_table = {}

for i = 1, zone_count, 1 do
	table.insert(zone_table, ZONE:New( zone_name_prefix .. i ))
end

Spawn_civil_ships = SPAWN:New( "Ziv_Naval-5" ) -- the parameter just has to contained in the ship_names, but it will be a random ship!
:InitRandomizeTemplate( ship_names )
:InitLimit( 100, 100 )
:InitRandomizeZones( zone_table )
:InitRandomizeRoute(0, 2, 5000)

local ship_Count = math.random(minnimum_ships, maximum_ships)
-- ***** SPAWN
for count = 1, ship_Count, 1 do
	Spawn_civil_ships:Spawn()
end
