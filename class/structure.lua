local class = require( "lib.middleclass" )
local Entity = require( "class.entity" )
local Unit = require( "class.unit" )

local Structure = class('Structure', Entity)

local STATE_IDLE = "IDLE"
local STATE_BUILDING = "BUILDING"

function Structure:initialize( world, team, x, y, radius, maxspeed, linear_damping, angular_damping, mass, sight_radius, target )
	-- Variable initializations
	local x, y = x or 0, y or 0
	local radius = radius or 2.0
	local maxspeed = maxspeed or 1 -- So fast, wow. o:
	local linear_damping, angular_damping = linear_damping or 1, angular_damping or 1 -- So dank... *Cough cough*, damp
	local mass = mass or 1 -- So dense, wow. o:
	local strenght = strenght or 10 -- So stronk, wow. o:
	local sight_radius = sight_radius or 4 + radius -- Give me vision beyond reach
	local default_target = {}
	default_target.x, default_target.y = x + radius * 2, y + radius * 2
	local target = target or default_target
	Entity.initialize( self, world, team, x, y, "static", radius, maxspeed, linear_damping, angular_damping, mass, sight_radius )
	
	-- Object variables
	self.build = nil -- Imma not gonna do anything!
	self.target = target
	self.state = STATE_IDLE
end

function Structure:draw( screen_manager )
	local sm = screen_manager
	local sx, sy = sm:getScreenPos( self:getCenter() )
	local r = sm:getLength( self:getRadius() )
	love.graphics.setColor( 0.5, 0.0, 0.0 )
	love.graphics.circle( "fill", sx, sy, r )
	love.graphics.setColor( 0.0, 0.0, 0.0 )
	love.graphics.circle( "fill", sx, sy, r / 10 )
end

function Structure:update( dt )
	if self.build ~= nil then
		local sx, sy = self:getCenter()
		local r = self:getRadius()
		self.build = nil
		self.state = STATE_IDLE
		return { Unit:new( self:getWorld(), self.team, sx + r, sy + r,  nil, nil, nil, nil, nil, nil, nil, self.target ) }
	end
end

function Structure:input( act, val )
	if act == "move_to" then
		self.target = val
	elseif act == "build" then
		self.build = val
		self.state = STATE_BUILDING
	end
end

return Structure
