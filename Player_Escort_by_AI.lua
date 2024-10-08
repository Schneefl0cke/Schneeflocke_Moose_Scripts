-- AI Planes will escort the client when this script is executed.
-- You can also add SEAD or A2G Escorts just like this.
-- In my missions I activate the Escort group with a radio command. This will simultaniousely call this script.
-- It could also be made so, that the Escort spawns on the ground, but you would have to wait for them to startup

-- Variables --
local _escortee_name = "Players-1" -- the unit name of the plane that shall be escorted
local _escort_group_nameprefix = "BLUE_A2A_ESCORT" -- all groups with this name will be added as escort. I place them as inactive in the air and activate them with the same radio call that calls this script
local _escort_callsign = "A2A Witwenmacher"
local _coalition = "blue" -- change red or blue
local _startMessage = "Escort 'Witwenmacher' is on station!"

-- MOOSE Code --

env.info("Starting Schneeflocke A2A Escort Script", false)

local _messageToCoalition = MESSAGE:New( _escortee_name .. " is now escorted by " .. _escort_callsign .. "!")
_messageToCoalition:ToCoalition( coalition.side.BLUE )

local _escort_group = SET_GROUP:New():FilterCategories( { "plane" } ):FilterCoalitions( _coalition ):FilterPrefixes( { _escort_group_nameprefix } ):FilterStart()
local _escortee = UNIT:FindByName( _escortee_name )
local _escort = AI_ESCORT:New( _escortee, _escort_group, _escort_callsign, _startMessage )
_escort:FormationTrail( 100, 100 , 0 )
_escort:MenusAirplanes()
_escort:_FlightROEWeaponFree("Weapons free!")
_escort:_FlightROTEvadeFire("Evading fire!")
_escort:__Start( 2 )

env.info("Finished A2A escort script", false)