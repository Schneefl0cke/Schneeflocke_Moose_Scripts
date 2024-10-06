-- AI Planes will escort the client when this script is executed.
-- In my missions I activate the Escort group with a radio command. This will simultaniousely call this script.
-- It could also be made so, that the Escort spawns on the ground, but you would have to wait for them to startup

-- Variables --
local _escortee_name = "Players-1" -- the unit name of the plane that shall be escorted
local _escort_prefix = "BLUE_ESCORT" -- all planes with this prefix will escort the escortee
local _escort_callsign = "Witwenmacher"
local _coalition = "blue" -- change red or blue
local _startMessage = "Escort 'Witwenmacher' is on station!"

-- MOOSE Code --

local _messageToCoalition = MESSAGE:New( _escortee_name .. " is now escorted by " .. _escort_callsign .. "!")
_messageToCoalition:ToCoalition( coalition.side.BLUE )

local _escort_group = SET_GROUP:New():FilterCategories( { "plane" } ):FilterCoalitions( _coalition ):FilterPrefixes( { _escort_prefix } ):FilterStart()
local _escortee = UNIT:FindByName( _escortee_name )
local _escort = AI_ESCORT:New( _escortee, _escort_group, _escort_callsign, _startMessage )
_escort:FormationTrail( 100, 100 , 0 )
_escort:MenusAirplanes()
_escort:_FlightROEWeaponFree("Weapons free!")
_escort:_FlightROTEvadeFire("Evading fire!")
_escort:__Start( 2 )