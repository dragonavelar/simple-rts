local class = require( "lib.middleclass" )
local Entity = require( "class.entity" )
local Unit = require( "class.unit" )

local Structure = class('Structure', Entity)

local STATE_IDLE = "IDLE"
local STATE_BUILDING = "BUILDING"

local default_target = function(x,y,r) return x + r + 2, y + r + 2 end

function Structure:initialize( args )
	args.radius = args.radius or 2.0
	args.target = args.target or default_target( args.x, args.y, args.radius )
	Entity.initialize( self,
		{
			world = args.world,
			team = args.team,
			x = args.x, y = args.y,
			body_type = "static",
			radius = args.radius,
			mass = args.mass or 1,
			sight_radius = args.sight_radius or 4 + args.radius
		}
	)
	
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
		return { Unit:new{ world = self:getWorld(), team = self.team, x = sx + r, y = sy + r, target = self.target } }
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
