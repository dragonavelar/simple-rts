local class = require( "lib.middleclass" )
local Entity = require( "class.entity" )

local Unit = class('Unit', Entity)

local STATE_IDLE = "IDLE"
local STATE_MOVING = "MOVING"

function Unit:initialize( args )
	-- Variable initializations
	args.radius = args.radius or 0.5
	Entity.initialize(
		self,
		{
			world = args.world,
			team = args.team,
			x = args.x,
			y = args.y,
			body_type = "dynamic",
			radius = args.radius,
			linear_damping = args.linear_damping,
			angular_damping = args.angular_damping,
			mass = args.mass or 1,
			sight_radius = args.sight_radius or 4 + args.radius
		}
	)
	
	-- Object variables
	self.strenght = args.strenght or 10 -- So stronk, wow o:
	self.target = args.initial_target -- Moving to position!
	self.state = STATE_IDLE
	self.maxspeed = args.maxspeed or 1000
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