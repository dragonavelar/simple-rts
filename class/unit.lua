local class = require( "lib.middleclass" )
local Entity = require( "class.entity" )

local Unit = class('Unit', Entity)

local STATE_IDLE = "IDLE"
local STATE_MOVING = "MOVING"

function Unit:initialize( world, team, x, y, radius, maxspeed, linear_damping, angular_damping, mass, sight_radius, strenght, initial_target )
	-- Variable initializations
	local x, y = x or 0, y or 0
	local radius = radius or 0.5
	local maxspeed = maxspeed or 1 -- So fast, wow. o:
	local linear_damping, angular_damping = linear_damping or 1, angular_damping or 1 -- So dank... *Cough cough*, damp
	local mass = mass or 1 -- So dense, wow. o:
	local strenght = strenght or 10 -- So stronk, wow. o:
	local sight_radius = sight_radius or 4 + radius -- Give me vision beyond reach
	Entity.initialize( self, world, team, x, y, "dynamic", radius, maxspeed, linear_damping, angular_damping, mass, sight_radius )
	
	-- Object variables
	self.strenght = strenght -- So stronk
	self.target = initial_target -- Moving to position!
	self.state = STATE_IDLE
end

function Unit:draw( screen_manager )
	local sm = screen_manager
	local sx, sy = sm:getScreenPos( self:getCenter() )
	local r = sm:getLength( self:getRadius() )
	love.graphics.setColor( 1.0, 0.0, 0.0 )
	love.graphics.circle( "fill", sx, sy, r )
end

function Unit:update( dt )
	if self.target ~= nil then
		self.state = STATE_MOVING
		local px, py = self.body:getWorldPoint( self.shape:getPoint() )
		--print( "Heigh-ho, heigh-ho, it's (" .. self.target.x .. ", " .. self.target.y .. ") from work I go! Pararatibum, pararatibum, heigh-ho, heigh-ho!" )
		local dx, dy = util.dist2d( px, py, self.target.x, self.target.y )
		local sx, sy = util.sign( dx ), util.sign( dy )
		local mx, my = util.normalize( sx, sy )
		self.body:applyForce( mx * self.strenght * dt, my * self.strenght * dt )
		if util.vec2dmod( self.body:getLinearVelocity() ) > self.maxspeed then
			local vx, vy = util.normalize( self.body:getLinearVelocity() )
			self.body:setLinearVelocity( vx * self.maxspeed, vy * self.maxspeed )
		end
		if util.vec2dmod( dx, dy ) < self.shape:getRadius() then
			self.state = STATE_IDLE
			self.target = nil
			self.body:setLinearVelocity( 0, 0 )
		end
	end
end

function Unit:input( act, val )
	if act == "move_to" then
		self.target = val
	end
end

return Unit