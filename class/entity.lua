local class = require( "lib.middleclass" )

local Entity = class('Entity')

local STATE_BAMBOOZLED = "BAMBOOZLED"

function Entity:initialize( world, team, x, y, type, radius, maxspeed, linear_damping, angular_damping, mass, sight_radius )
	-- Variable initializations
	local x, y = x or 0, y or 0 -- I'm in position!
	local radius = radius or 1 -- Do I look fat?
	local maxspeed = maxspeed or 1 -- So fast, wow. o:
	local linear_damping, angular_damping = linear_damping or 1, angular_damping or 1 -- So dank... *Cough cough*, damp
	local mass = mass or 1 -- So dense, wow. o:
	local strenght = strenght or 11 -- So stronk, wow. o:
	local sight_radius = sight_radius or 1 + radius -- Give me vision beyond reach
	local type = type or "dynamic"
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, type )
	self.body:setAngularDamping( angular_damping )
	self.body:setLinearDamping( linear_damping )
	self.body:setMass( mass )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newCircleShape( radius )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Gotta go fast
	self.maxspeed = maxspeed
	-- Object variables
	self.team = team
	self.sight_radius = sight_radius
	self.state = STATE_BAMBOOZLED
	self.alive = true
end

function Entity:draw( screen_manager )
	print( "O noes, I'm being drawn and I don't know what sprite I should use!" )
	local sm = screen_manager
	local sx, sy = sm:getScreenPos( self.body:getWorldPoint( self.shape:getPoint() ) )
	local r = sm:getLength( self.shape:getRadius() )
	love.graphics.setColor( 1.0, 1.0, 1.0 )
	love.graphics.circle( "fill", sx, sy, r )
end

function Entity:update( dt )
	print( "O noes, I'm being updated and don't know what to do! I'm currently" .. self.state )
end

function Entity:input( act, val )
	print( "O noes, I was commanded to " .. tostring( act ) .. " " .. tostring( val ) .. " and don't know what to do!"  )
end

function Entity:collide( obj, coll )
	print( "O noes, I hit a: " .. tostring( obj ) .. " and don't know what to do!" )
end

function Entity:disableCollision( obj, coll )
	print( "O noes, I have to know if I can disable collisions, but I don't know if I can! I won't, though." )
	return false
end

function Entity:getCenter()
	return self.body:getWorldPoint( self.shape:getPoint() )
end

function Entity:getRadius()
	return self.shape:getRadius()
end

function Entity:getWorld()
	return self.body:getWorld()
end

function Entity:__tostring()
	retval = tostring(self.class) .. ": { "
	for k, v in pairs( self ) do
		retval = retval .. tostring( k ) .. ":" .. tostring( v ) .. ", "
	end
	return retval .. " }"
end

return Entity