local thisFile = 'lib.cam'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Cam class , virtual camera for drawing world map and game objects
Cam = {}

function Cam.new(init)
	local self		= init

		self.isEveryOtherFrame = true
		self.refTick = 16 -- reference tick is 16 ms or 1 frame @ 62.5fps, used for uniform display/motion rate across differing devices and frame rates
		self.actTick = 0	-- actual tick
		self.prevTime = 0
		self.curTime = 0
		self.ticksPerFrame = 0
		self.pixelsPerFrame = 0
		self.pixelsPerFrameInt = 0
		self.tx = 0									-- Camera Transition X, total amount to transition the camera
		self.ty = 0
		self.tdx = 4								-- Transition dx, amount per frame to shift towards transition X
		self.tdy = 4
		self.tdxRemainder = 0
		self.tdyRemainder = 0
		--self.velocity = 0.0072		-- tiles per tick @ 60fps
		self.refVelocity = 0.0072		-- reference velocity (tiles per reference tick) , modify this to increase or decrease game rate
		self.actVelocity = 0				-- actual velocity  =  (refTick / actTick) * refVelocity
		--self.isWorldMap = false

		g.screen.pixelsPerTile = g.screen.tileSize

		g.screen.xTile0Centered = 0
		g.screen.yTile0Centered = 0

		self.x = g.screen.xTile0Centered + g.screen.pixelsPerTile * 24 -- 24 is tile coordinate x
		self.y = g.screen.yTile0Centered + g.screen.pixelsPerTile * 18 -- 18 is tile coordinate y

		self.xMax = 0 -- initialized in level loader
		self.yMax = 0

		self.xPrevCollision = -1
		self.yPrevCollision = -1

	--****************************************************
	function self:initializeFrame()
		local thisFunc = 'initFrame()'
		--if (dbg) then dbg.out(thisFile,thisFunc, 'Cam: ') end
		g.cam.curTime = system.getTimer()
		g.cam.actTick = g.cam.curTime - g.cam.prevTime
		g.cam.prevTime = g.cam.curTime
		g.cam.actVelocity = (g.cam.refTick / g.cam.actTick) * g.cam.refVelocity

		g.cam.tdx = g.cam.tdxRemainder + 2000 * g.cam.actVelocity		-- add remainder from previous frame
		g.cam.tdy = g.cam.tdyRemainder + 2000  * g.cam.actVelocity

		g.cam.tdxRemainder = g.cam.tdx - math.floor(g.cam.tdx)			-- store remainder for next frame
		g.cam.tdyRemainder = g.cam.tdy - math.floor(g.cam.tdy)

		g.cam.tdx = g.cam.tdx - g.cam.tdxRemainder	-- make integer for pixel transition
		g.cam.tdy = g.cam.tdy - g.cam.tdyRemainder
	end
	
		--****************************************************
	function self:transitionFrame()
		local thisFunc = 'transitionFrame()'
		--if (dbg) then dbg.out(thisFile,thisFunc, 'Cam: ') end

		-- transition in positive x direction
		if g.cam.tx > 0 then												-- is there more transition distance to go from point a to point b
			if g.cam.tx < g.cam.tdx then 							-- is there less shift then the standard shift per tick
				g.imggroup.x = g.imggroup.x + g.cam.tx 	-- shift the tile sheets by remaining transition distance
				g.cam.tx = 0														-- transition is completed, reached point b
			else																			-- is standard shift per tick
				g.imggroup.x = g.imggroup.x + g.cam.tdx	-- shift the tile sheets by standard transition distance per tick
				g.cam.tx = g.cam.tx - g.cam.tdx					-- total transition distance minus standard shift per tick
			end

		-- transition in negative x direction
		elseif g.cam.tx < 0 then										-- is there more transition distance to go from point a to point b
			if -g.cam.tx < g.cam.tdx then							-- is there less shift then the standard shift per tick
				g.imggroup.x = g.imggroup.x - g.cam.tx	-- shift the tile sheets by remaining transition distance
				g.cam.tx = 0														-- transition is completed, reached point b
			else																			-- is standard shift per tick
				g.imggroup.x = g.imggroup.x - g.cam.tdx	-- shift the tile sheets by standard transition distance per tick
				g.cam.tx = g.cam.tx + g.cam.tdx					-- total transition distance minus standard shift per tick
			end
		end

		-- transition in positive y direction
		if g.cam.ty > 0 then												-- is there more transition distance to go from point a to point b
			if g.cam.ty < g.cam.tdy then 							-- is there less shift then the standard shift per tick
				g.imggroup.y = g.imggroup.y + g.cam.ty 	-- shift the tile sheets by remaining transition distance
				g.cam.ty = 0														-- transition is completed, reached point b
			else																			-- is standard shift per tick
				g.imggroup.y = g.imggroup.y + g.cam.tdy	-- shift the tile sheets by standard transition distance per tick
				g.cam.ty = g.cam.ty - g.cam.tdy					-- total transition distance minus standard shift per tick
			end

		-- transition in negative y direction
		elseif g.cam.ty < 0 then										-- is there more transition distance to go from point a to point b
			if -g.cam.ty < g.cam.tdy then							-- is there less shift then the standard shift per tick
				g.imggroup.y = g.imggroup.y - g.cam.ty	-- shift the tile sheets by remaining transition distance
				g.cam.ty = 0														-- transition is completed, reached point b
			else																			-- is standard shift per tick
				g.imggroup.y = g.imggroup.y - g.cam.tdy	-- shift the tile sheets by standard transition distance per tick
				g.cam.ty = g.cam.ty + g.cam.tdy					-- total transition distance minus standard shift per tick
			end
		end

	end

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, 'Cam: ')

	end

	--****************************************************

	return self

end