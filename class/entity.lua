local class = require( "lib.middleclass" )

local Entity = class('Entity')

local STATE_BAMBOOZLED = "BAMBOOZLED"

function Entity:initialize( args )
	-- Variable initializations
	if type( args.world ) ~= "userdata" then error("Remember to send a world!") end
	args.team = args.team or 0
	args.x, args.y = args.x or 0, args.y or 0 -- I'm in position!
	args.radius = args.radius or 1 -- Do I look fat?
	args.body_type = args.body_type or "dynamic"
	args.linear_damping, args.angular_damping = args.linear_damping or 1, args.angular_damping or 1 -- So dank... *Cough cough*, damp
	args.mass = args.mass or 1 -- So dense, wow. o:
	if args.fixed_rotation == nil then args.fixed_rotation = true end
	args.sight_radius = args.sight_radius -- Give me vision beyond reach
	-- Let the body hit the floor
	self.body = love.physics.newBody( args.world, args.x, args.y, args.body_type )
	self.body:setAngularDamping( args.angular_damping )
	self.body:setLinearDamping( args.linear_damping )
	self.body:setMass( args.mass )
	self.body:setFixedRotation( args.fixed_rotation )
	-- The shape of you
	self.shape = love.physics.newCircleShape( args.radius )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Object variables
	self.team = args.team
	self.sight_radius = args.sight_radius
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