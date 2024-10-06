-- Example for the CAP_Intercept Script

-- This script creates CAP and Interceptors in given zones using Moose. You will need to extend and adapt it based on the examples in the script. 
-- The goal is randomization, since I play the missions I create myself but dont want to know everything that happens.
-- you still need to adapt the SETUP_FIGHTER_COMMAND function to your liking, until I add more decent randomization

--Steps to add more fighters:
-- add a new warehouse + CAP Zone + Airwing if you want the fighters to spawn from a new airport. For each flight add a mission to the CAP zone. Dont forget to assign the airport to the correct side.
-- add fighter squadron to Airwing

-- **** Setup adviced by math lib
math.random()
math.random()
math.random()
env.info("Starting Schneeflocke Omnien CAP!", false)
-- ****

-- General variables
local _faction_red = true --set to false if you want a blue CAP/Intercept
local _name_of_faction = "Omnien"
local _name_prefix_of_EWR_Units = "RED_EWR" -- All units with this as their prefix in the name will be added as information for the fighter command. You must create some EWR units, since the CAP needs ground control to intercept. 
local _homeland = ZONE_POLYGON:NewFromGroupName("Red_Border") --Create a unit called 'Homeland', the waypoints of the unit will be the main area of defense
--

-- CAP zone names
local _cap_zone_1_name = "Red_Bandar_AirZone"
local _cap_zone_2_name = "Red_Kish_AirZone"

-- Fighter Setup. If you want to add more airframe variation, you must extend the GetFighterType function!
local _fighter_min = 4 -- the minnimum available fighters per squadron
local _fighter_max = 8 -- maximal available fighters per squadron
local _mission_range_min = 100
local _mission_range_max = 200

--fighter types
local _fighter_type_1 = "Omnien-AF-Skyhawk" -- Name of the unit in DCS. Give the unit the correct loadout and skin!
local _readiness_fighter_1 = 85 -- Propability that the fighters are on station, or all are grounded. As percentage value of 100
local _fighter_type_1_capability = 50 -- how good is the fighter

local _fighter_type_2 = "Omnien-AF-F-5" -- Name of the unit in DCS. Give the unit the correct loadout and skin!
local _readiness_fighter_2 = 70 -- Propability that the fighters are on station, or all are grounded. As percentage value of 100
local _fighter_type_2_capability = 70
--

--warehouses
local _warehouse_1 = "Warehouse Bandar" -- You need to add a structure next to an airport with this name.
local _warehouse_2 = "Warehouse Kish" -- You need to add a structure next to an airport with this name.
--

-- names
local _airwing_1_name = "Airwing 1"
local _airwing_2_name = "Airwing 2"
local _squadron_1_name = " Squadron 1" -- space because it will be merged with faction name
local _squadron_2_name = " Squadron 2"
local _squadron_3_name = " Squadron 3"

-- How is the grouping of the enemy flights? The sum does not need to be 100
local _propability_1_ship_flight = 40
local _propability_2_ship_flight = 40
local _propability_3_ship_flight = 0
local _propability_4_ship_flight = 20
--

--------------------------------------
--| CHANGE BELOW HERE AT OWN RISK! |--
--------------------------------------

-- Chief Setup
local _agents=SET_GROUP:New():FilterPrefixes(_name_prefix_of_EWR_Units):FilterOnce()
local _fighter_command
if _faction_red == true then
    _fighter_command = CHIEF:New(coalition.side.RED, _agents)
else
    _fighter_command = CHIEF:New(coalition.side.BLUE, _agents)
end

_fighter_command:AddBorderZone(_homeland)
_fighter_command:SetTacticalOverviewOn()

local function GetFighterGroupingCount()
    local _2ship = _propability_1_ship_flight + _propability_2_ship_flight
    local _3ship = _2ship + _propability_3_ship_flight
    local _4ship = _3ship + _propability_4_ship_flight
    local prop = math.random(_4ship)

    if prop < _propability_1_ship_flight then
        return 1
    elseif prop < _2ship then
        return 2
    elseif prop < _3ship then
        return 3
    elseif prop < _4ship then
        return 4
    end
end

local function setup_airwing_1 ()

    --- AIRWING 1
    local _airwing_1=AIRWING:New(_warehouse_1, _airwing_1_name) --Ops.AirWing#AIRWING
    _airwing_1:NewPayload(_fighter_type_1, -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.CAP}, 80)
    _airwing_1:NewPayload(_fighter_type_2, -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.CAP}, 80)
    _fighter_command:AddAirwing(_airwing_1)
    --******

    -- SQUADRON 1
    if math.random(_readiness_fighter_1) < 100 then
        local _available_fighters = math.random(_fighter_min, _fighter_max)
        local _squadron = SQUADRON:New(_fighter_type_1, _available_fighters, _name_of_faction .. _squadron_1_name)
        local _grouping = GetFighterGroupingCount()
        env.info("Squadron 1 Bandar Abbas spawned with " .. _available_fighters .. " fighters and a grouping of " .. _grouping, false)
        _squadron:SetGrouping(_grouping) -- Random grouping
	    _squadron:SetModex(100)  -- Tail number of the sqaud start with 130, 131,...
	    _squadron:AddMissionCapability({AUFTRAG.Type.INTERCEPT}, _fighter_type_1_capability) -- Squad can do intercept missions.
        _squadron:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
        _squadron:AddMissionCapability(AUFTRAG.Type.CAP,_fighter_type_1_capability)
	    local missionrange = math.random(_mission_range_min, _mission_range_max)
	    _squadron:SetMissionRange(missionrange) -- Squad will be considered for targets within 200 NM of its airwing location.
	    _airwing_1:AddSquadron(_squadron)
    else
        env.info("Squadron 1 not spawned.", false)
    end

    -- SQUADRON 2
    if math.random(_readiness_fighter_2) < 100 then
        local _available_fighters = math.random(_fighter_min, _fighter_max)
        local _squadron_2 = SQUADRON:New(_fighter_type_2, _available_fighters, _name_of_faction .. _squadron_2_name)
        local _grouping = GetFighterGroupingCount()
        env.info("Squadron 2 Bandar Abbas spawned with " .. _available_fighters .. " fighters and a grouping of " .. _grouping, false)
        _squadron_2:SetGrouping(_grouping) -- Random grouping
        _squadron_2:SetModex(200)  -- Tail number of the sqaud start with 130, 131,...
        _squadron_2:AddMissionCapability({AUFTRAG.Type.INTERCEPT}, _fighter_type_2_capability) -- Squad can do intercept missions.
        _squadron_2:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
        _squadron_2:AddMissionCapability(AUFTRAG.Type.CAP,_fighter_type_2_capability)
        local missionrange = math.random(_mission_range_min, _mission_range_max)
        _squadron_2:SetMissionRange(missionrange) -- Squad will be considered for targets within 200 NM of its airwing location.
        _airwing_1:AddSquadron(_squadron_2)
    else
        env.info("Squadron 2 not spawned.", false)
    end
end

local function setup_airwing_2()
     --- AIRWING 2
     local _airwing_2 = AIRWING:New(_warehouse_2, _airwing_2_name) --Ops.AirWing#AIRWING
     _airwing_2:NewPayload(_fighter_type_1, -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.CAP}, 80)
     _airwing_2:NewPayload(_fighter_type_2, -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.CAP}, 80)
     _fighter_command:AddAirwing(_airwing_2)
     --******

    -- SQUADRON 3
    if math.random(_readiness_fighter_1) < 100 then
        local _available_fighters = math.random(_fighter_min, _fighter_max)
        local _squadron_3 = SQUADRON:New(_fighter_type_1, _available_fighters, _name_of_faction .. _squadron_3_name)
        local _grouping = GetFighterGroupingCount()
        env.info("Squadron 3 Kish spawned with " .. _available_fighters .. "scriptfighters and a grouping of " .. _grouping, false)
        _squadron_3:SetGrouping(_grouping) -- Random grouping
	    _squadron_3:SetModex(300)  -- Tail number of the sqaud start with 130, 131,...
	    _squadron_3:AddMissionCapability({AUFTRAG.Type.INTERCEPT}, _fighter_type_1_capability) -- Squad can do intercept missions.
        _squadron_3:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
        _squadron_3:AddMissionCapability(AUFTRAG.Type.CAP,_fighter_type_1_capability)
	    local missionrange = math.random(_mission_range_min, _mission_range_max)
	    _squadron_3:SetMissionRange(missionrange) -- Squad will be considered for targets within 200 NM of its airwing location.
	    _airwing_2:AddSquadron(_squadron_3)
    else
        env.info("Squadron 3 not spawned.", false)
    end
end

local function setup_cap_zones()
    -- CAP only between 0500 and 20000
	if (timer.getAbsTime() > 18000 and timer.getAbsTime() < 72000) then
		--CAP Zones
		local _CAP_zone_1 = ZONE_POLYGON:NewFromGroupName(_cap_zone_1_name)
		_fighter_command:AddCapZone(_CAP_zone_1,15000,240,270,30) -- Zone, Altitude, Speed, Heading, Leg
		_fighter_command:AddCapZone(_CAP_zone_1,20000,240,270,30) -- second group!

        local _CAP_zone_2 = ZONE_POLYGON:NewFromGroupName(_cap_zone_2_name)
		_fighter_command:AddCapZone(_CAP_zone_2,15000,240,270,30) -- Zone, Altitude, Speed, Heading, Leg
        _fighter_command:AddCapZone(_CAP_zone_2,20000,240,270,30) -- second group
	end
end

setup_airwing_1()
setup_airwing_2()
setup_cap_zones() -- CAP is only spawned at day!
_fighter_command:__Start(1)
