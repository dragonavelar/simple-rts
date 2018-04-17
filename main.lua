require( "util" )
require( "collisions" )
local Entity = require( "class.entity" )
local Unit = require( "class.unit" )
local Structure = require( "class.structure" )
local Screen_manager = require( "class.screen_manager" )
local sm = Screen_manager:new()
local entities = {}
local world = nil

function love.load()
	world = love.physics.newWorld()
	world:setCallbacks( collisions.beginContact, collisions.endContact, collisions.preSolve, collisions.postSolve )
	table.insert( entities, Unit:new( world, 0, 1, 1 ) )
	table.insert( entities, Unit:new( world, 0, 1, 3 ) )
	table.insert( entities, Structure:new( world, 0, 6, 6 ) )
end

function love.update( dt )
	local k, v, ks, vs = nil, nil, nil, nil
	sm:update( dt )
	world:update( dt )
	local spawned = {}
	for k, v in pairs( entities ) do
		vspawn = v:update( dt )
		-- Log created entities to be added to the entity pool
		for ks, vs in pairs( vspawn or {} ) do
			table.insert( spawned, vs )
		end
		-- Delete entity from entity pool
		if not v.alive then
			-- TODO: Mark entitity for deletion
			table.remove( entities, k )
		end
	end
	-- Insert created entities in the entity pool
	for k, v in pairs( spawned ) do
		table.insert( entities, v )
	end
end

function love.draw()
	for k, v in pairs( entities ) do
		v:draw( sm )
	end
end


function love.mousereleased( x, y, button, istouch )
	local wx, wy = sm:getWorldPos( x, y )
	local target = {}
	target.x, target.y = wx, wy
	for k, v in pairs( entities ) do
		v:input( "move_to", target )
	end
end

function love.mousepressed( x, y, button, istouch )
end

function love.keypressed( key, scancode )
	if key == "space" then
		for k, v in pairs( entities ) do
			v:input( "build", true )
		end
	end
	sm:input( scancode, true )
end

function love.keyreleased( key, scancode )
	sm:input( scancode, false )
end










-- Altered main function that caps fps at 60 and lets update to run indefinetely

function love.run()
	if love.math then
		love.math.setRandomSeed( os.time() )
	end
	math.randomseed( os.time() )
	math.random(); math.random(); math.random();

	if love.load then love.load( arg ) end

	love.timer.step()
	local dt = 0
	local u_dt = 0
	local acc = 0
	local tbu = 0
	local tau = 0
	local rest_time = 0.001

	-- Main loop
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return a
					end
				end
				love.handlers[ name ]( a, b, c, d, e, f )
			end
		end

		love.timer.step()
		dt = love.timer.getDelta()
		if dt > 1/30 then u_dt = 1/30 else u_dt = dt end

		tbu = love.timer.getTime()
		love.update( u_dt )
		tau = love.timer.getTime()

		-- Update screen, frames capped at 60 fps for drawing
		if love.graphics and love.graphics.isActive() then
			acc = acc + dt
			if acc > 1/60 then
				love.graphics.clear( love.graphics.getBackgroundColor() )
	love.graphics.origin()
				love.draw()
				love.graphics.present()
				while acc > 1/60 do acc = acc - 1/60 end
			end
		end

		-- Rest for a while if we haven't done a lot of processing already
		if tau - tbu < rest_time then
			love.timer.sleep( rest_time - tau + tbu )
		end
	end
end
