local thisFile = g.dir.main..'levelLoader'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

function round(fNum)
  return math.floor(fNum + 0.5)
end
--------------------------------------------------------------------------------------------------
--local group = {}
local direction = 0
local deltaDirection = 1

--g.cam.xMax = world.width * g.screen.pixelsPerTile - display.viewableContentWidth
--g.cam.yMax = world.height * g.screen.pixelsPerTile - display.viewableContentHeight

--require(g.dir.library..'layer')
--if (dbg) then dbg.out(thisFile, thisFunc, pn.uuid) end
--pn.connect(pn.mainChannel)

--****************************************************
--g.cam.prevTime = system.getTimer()
--g.cam.curTime = system.getTimer()
local ticksPerFrame = nil

local scene = sb.newScene()

-- forward declarations
local object1, object2

--****************************************************
--[[
function myTile(fScreenX,fScreenY)
	local thisFunc = 'myTile'
	local realX = g.cam.x + fScreenX
	local realY = g.cam.y + fScreenY

	local ret = {}
	ret[1] = math.floor(realX / g.screen.pixelsPerTile) + 1 -- tileX
	ret[2] = math.floor(realY / g.screen.pixelsPerTile) + 1 -- tileY
	return ret
end
--]]
--****************************************************
function physicsTiles(fTileX, fTileY) -- returns physics tiles as array. 1 = right tile, 2 = bottom tile, 3 = left tile, 4 = top tile
	local thisFunc = 'myTile'
end

--****************************************************
function scene:createScene(event)
	local thisFunc = 'createScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end


	g.mobgroup = display.newGroup()
	g.mobgroup:insert(g.mob.player)
	g.mobgroup:insert(g.joystick.cursor)
	g.mobgroup:toFront()

	local isVisible = true
	g.mob.player.isVisible = isVisible
	g.imggroup.isVisible = isVisible
	g.joystick.cursor.isVisible = isVisible
	g.cam.prevTime = system.getTimer()
	g.isEnterFrame = true

	local tileState = 1

		for x = 1, g.map.width do
			for y = 1, g.map.height do

				local overlayCur = g.level.overlay[x][y]
				local underlayCur = g.level.underlay[x][y]

				local overlayPrev = g.map.overlay[x][y].frame
				local underlayPrev = g.map.underlay[x][y].frame

				if (overlayCur ~= overlayPrev) then
					g.map.overlay[x][y]:setFrame(overlayCur)
				end

				if (underlayCur ~= underlayPrev) then
					g.map.underlay[x][y]:setFrame(underlayCur)
				end

				-- g.map.overlay[x][y]:setFrame(overTile)
				-- g.map.underlay[x][y]:setFrame(underTile)

				-- g.map.underlay[x][y]:play()
				-- g.map.overlay[x][y]:play()
			end
		end

--[[

	-------------------------------- world layer (aka ground layer)
	-- LAYER INDEX, world = 1, overlay = 2, physics = 3 
	if (dbg) then dbg.out(thisFile, thisFunc, 'create world layer') end

local worldSheet = initImageSheet('world', g.screen.tilesPerSheet)
local worldSheet = initImageSheet(g.screen.imgSheet,g.screen.tilesPerSheet)
worldMap = initMap(worldSheet,world.width,world.height)
	initScreen(worldMap, worldSheet, g.screen.tilesPerSheet)
	loadMap(worldMap,world, 1)
	g.cam.x = worldMap.xScroll
	g.cam.y = worldMap.yScroll	

--	local worldSheet = initImageSheet('world', g.screen.tilesPerSheet)
--	local worldSheet = initImageSheet(g.screen.imgSheet,g.screen.tilesPerSheet)
--	worldMap = initMap(worldSheet,world.width,world.height)
	initScreen(worldMap, worldSheet, g.screen.tilesPerSheet)
	loadMap(worldMap,world, 1)
	--g.cam.x = worldMap.xScroll
	--g.cam.y = worldMap.yScroll	
	-- draw g.hud display objects

	-------------------------------- physics layer
	imgGroup =  display.newImageGroup( g.imgsheet[1] )

	group = display.newGroup()
	group:insert( g.joystick.cursor )
	--imgGroup:insert( g.joystick.cursor )

--	local mobImgGroup = display.newImageGroup(g.imgsheet.nomsy)
--	mobImgGroup:insert(g.mob.player)
--	group:insert(g.mob.player)
	imgGroup:insert(g.mob.player)
	g.mob.player.isVisible = true
	g.mob.player:play()

	g.screen.xMinPhysicsRenderWindow = -96 + g.screen.xMid
	g.screen.yMinPhysicsRenderWindow = -96 + g.screen.yMid
	g.screen.xMaxPhysicsRenderWindow = 96 + g.screen.xMid
	g.screen.yMaxPhysicsRenderWindow = 96 + g.screen.yMid

	if (dbg) then dbg.out(thisFile, thisFunc, 'create physics layer') end

	local topLeftTile = {}
	topLeftTile = myTile( 0, 0 )

	local bottomRightTile = {}
	bottomRightTile = myTile( g.screen.width-1, g.screen.height-1 )
	
	if (dbg) then dbg.out(thisFile, thisFunc, 'g.screen.tilesInView x,y '..g.screen.xTilesInView..' '..g.screen.yTilesInView) end
	for y = topLeftTile[2], (topLeftTile[2] + g.screen.yTilesInView - 1) do
		for x = topLeftTile[1], (topLeftTile[1] + g.screen.xTilesInView - 1) do
			local index = x + (y-1) * 48
			if (physicsArray.data[index] ~= 0) then
				--local pTile = display.newRect(0, 0, g.screen.pixelsPerTile-1, g.screen.pixelsPerTile-1)

				local pTile = display.newImage( g.imgsheet.nomsy, 1 )
				
				pTile.type = 'physicsTile'
				pTile:setFillColor(255, 255, 255)
				pTile.x = (x - topLeftTile[1] + 1) * g.screen.pixelsPerTile - g.screen.pixelsPerHalfTile + (g.cam.x % g.screen.pixelsPerTile)
				pTile.y = (y - topLeftTile[2] + 1) * g.screen.pixelsPerTile - g.screen.pixelsPerHalfTile + (g.cam.x % g.screen.pixelsPerTile)
				pTile.isVisible = false
				pTile:setReferencePoint(display.CenterReferencePoint)
				
				--group:insert(pTile)
				imgGroup:insert(pTile)

				local shapeBase = { 12,-5, 12,14, -12,14, -12,-5 }
				shape = {}
				for i=1,#shapeBase do
				shape[i] = round(shapeBase[i] * (g.screen.pixelsPerTile/g.screen.pixelsPerTile3gs))
				--print(round(nomsyShapeBase[i] * (g.screen.pixelsPerTile/g.screen.3gsPixelsPerTile)))
				end
				physics.addBody( pTile, 'static', { density=3.0, friction=0.8, bounce=0.3, shape=shape } )

			end
		
		end
	end
--]]

	--worldMap.xScroll = g.cam.x
	--worldMap.yScroll = g.cam.y

--	updateDisplay(worldMap,world,'','')


	--**************************************************** drag() Function Within createScene()
	local prevX, prevY
	local function drag(event)
		local thisFunc = 'drag'
		--if (dbg) then dbg.func('drag') end

		g.imggroup.isVisible = true

		---------------------------------------------------
		if event.phase == 'began' then
			g.joystick.xPrev = g.joystick.xCur
			g.joystick.yPrev = g.joystick.yCur
			g.joystick.xCur = event.x
			g.joystick.yCur = event.y

			g.joystick.dxCenter = g.joystick.xCur - (display.viewableContentWidth / 2)
			g.joystick.dyCenter = g.joystick.yCur - (display.viewableContentHeight / 2)
			g.cam.tx = g.joystick.dxCenter
			g.cam.ty = g.joystick.dyCenter


			if (dbg) then 
				dbg.devOut(g.joystick.dxCenter..' '..g.joystick.dyCenter)
				dbg.devOut(g.cam.actTick)
				dbg.devOut(g.cam.actVelocity)
			end
			
			g.joystick.dx = g.joystick.xCur - g.joystick.xPrev
			g.joystick.dy = g.joystick.yCur - g.joystick.yPrev

			g.joystick.cursor.x = g.joystick.xCur
			g.joystick.cursor.y = g.joystick.yCur

			if (g.joystick.xCur > (g.screen.width - 80) and g.joystick.yCur > (g.screen.height - 80) ) then
				local nPossibleTileSizes = table.getn(g.imgsheet.tileSizesAvailable)
				local index = (tileState % nPossibleTileSizes) + 1
				tileState = tileState + 1

				g.map:delete()
				g.collectGarbage()
				g.deleteImgGroupAndSheet()
				g.collectGarbage()
				g:changeImgGroupAndSheet(tostring(g.imgsheet.tileSizesAvailable[index]))
				g.map:create()
				g.mobgroup:toFront()
				g.map:render()
				
			end

		---------------------------------------------------
		elseif event.phase == 'moved' then
			---------
			-- g.joystick.xCur = event.x
			-- g.joystick.yCur = event.y

			--if (dbg) then dbg.out(thisFile, thisFunc, 'event.x event.y '..g.tap.xCur..' '..g.tap.yCur) end
			--if (dbg) then dbg.out(thisFile, thisFunc, 'event.x event.y '....' '..) end

			-- g.joystick.dx = g.joystick.xCur - g.joystick.xPrev
			-- g.joystick.dy = g.joystick.yCur - g.joystick.yPrev

			-- local dxTemp = 0
			-- local dyTemp = 0

		--	dxTemp = math.abs(g.joystick.dx)
		--	dyTemp = math.abs(g.joystick.dy)

--[[
			---------
			if (dxTemp > dyTemp and dxTemp > g.joystick.threshold) then
				g.joystick.dy = 0
				if (g.joystick.dx > 0 and g.mob.player.sequence ~= 'right') then
					g.mob.player:setSequence('right')
					g.mob.player:play()
				elseif (g.joystick.dx < 0 and g.mob.player.sequence ~= 'left') then
					g.mob.player:setSequence('left')
					g.mob.player:play()
				end
				
			elseif (dxTemp < dyTemp and dyTemp > g.joystick.threshold) then
				g.joystick.dx = 0
				if (g.joystick.dy > 0 and g.mob.player.sequence ~= 'down') then
					g.mob.player:setSequence('down')
					g.mob.player:play()
				elseif (g.joystick.dy < 0 and g.mob.player.sequence ~= 'up') then
					g.mob.player:setSequence('up')
					g.mob.player:play()
				end

			else
				g.joystick.dx = 0
				g.joystick.dy = 0
			end
			---------
			if (g.joystick.dx == 0 and g.joystick.dy == 0) then
			elseif (g.joystick.dx == 0) then
				g.cam.velocity = dyTemp/10000
			elseif (g.joystick.dy == 0) then
				g.cam.velocity = dxTemp/10000
			end
			---------
			if g.cam.velocity > 0.01 then
				g.cam.velocity = 0.01
			end
			---------
			-- set camera to approx infinite transitionX and transitionY, (will continue moving until set back to zero on joystick release)
			g.cam.tx = g.joystick.dx * 1000000
			g.cam.ty = g.joystick.dy * 1000000
		---------------------------------------------------
--]]
		elseif event.phase == 'ended' then

			--if (dbg) then dbg.out(thisFile, thisFunc, 'TAPOUT') end
--			g.joystick.xPrev = 0
--			g.joystick.yPrev = 0
--			g.joystick.xCur = 0
--			g.joystick.yCur = 0
--			g.joystick.dx = 0
--			g.joystick.dy = 0
--			g.cam.tx = 0
--			g.cam.ty = 0

--			g.joystick.cursor.isVisible = false
			--g.cam.velocity = 0.0072 -- tiles per tick
--[[
--]]
			--sb.gotoScene(g.dir.main..'main' )
			--sb.reloadScene('levelLoader')


--			if (dbg) then 
--				dbg.devOut(g.cam.x..' '..g.cam.y..' | '..g.level.width..' '..g.level.height..' | '..g.imgsheet.tileSize)
--			end

		end

		---------------------------------------------------

	end -- end drag function
	Runtime:addEventListener('touch', drag)
	--**************************************************** end drag function

end -- end createScene function
scene:addEventListener( 'createScene', scene )

--****************************************************
function scene:willEnterScene( event )
	local thisFunc = 'willEnterScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end
	
--object1.isVisible = false
--object2.isVisible = false
end
scene:addEventListener( 'willEnterScene', scene )

--********************************************************************************************************
--******* onUpdate START
--********************************************************************************************************
local function onEnterFrame( event )
	local thisFunc = 'onEnterFrame'
	--if (dbg) then dbg.func(thisFile, thisFunc) end
if g.isEnterFrame then

	g.cam:initializeFrame()
	g.cam:transitionFrame()


	if (dbg) then 
		--dbg.devOut(g.cam.tx..' '..g.cam.ty)
		--dbg.devOut(g.cam.tick)
	end



--]]

--[[
	if g.joystick.dyCenter > 0 then
		g.imggroup.y = g.imggroup.y + 1
	else
		g.imggroup.y = g.imggroup.y - 1
	end
--]]
	--	g.map.underlay[x][y]:setFrame(g.level.underlay[x][y])
	--	g.map.overlay[x][y]:setFrame(g.level.overlay[x][y])

--***********************************************************
--***********************************************************
-- This render code only needs to be drawn when edge drawing is necessary
-- Only happens when tile border crossing at screen edge
--[[
		for x = 1, g.map.width do
			for y = 1, g.map.height do

				local overlayCur = g.level.overlay[x][y]
				local underlayCur = g.level.underlay[x][y]

				local overlayPrev = g.map.overlay[x][y].frame
				local underlayPrev = g.map.underlay[x][y].frame

				if (overlayCur ~= overlayPrev) then
					g.map.overlay[x][y]:setFrame(overlayCur)
				end

				if (underlayCur ~= underlayPrev) then
					g.map.underlay[x][y]:setFrame(underlayCur)
				end

			end
		end
--]]

--[[

	if (g.joystick.dx > 0) then
		for x = 1, g.map.width do
			for y = 1, g.map.height do
--				g.map.underlay[x][y]:setFrame(2)
				
				g.map.underlay[x][y]:setFrame(g.level.underlay[x][y])
				g.map.overlay[x][y]:setFrame(g.level.overlay[x][y])
				
				-- = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=tile, count=1, time=0 })

			end
		end

	else
		for x = 1, g.map.width do
			for y = 1, g.map.height do
--				g.map.overlay[x][y]:play()
				-- = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=tile, count=1, time=0 })

			end
		end

	end
--]]

--[[
		for x = 1, g.map.width do
			g.map.overlay[x] = {}
			for y = 1, g.map.height do
				print(x,',',y,' g.level.overlay[x][y]',g.level.overlay[x][y])
				local tile = g.level.overlay[x][y]
				if tile == 0 then tile = g.imgsheet.transparentTile end
				g.map.overlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=tile, count=1, time=0 })
				g.map.overlay[x][y].x = x * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				g.map.overlay[x][y].y = y * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				g.map.overlay[x][y].width = g.imgsheet.tileSize
				g.map.overlay[x][y].height = g.imgsheet.tileSize
--				g.map.overlay[x][y].xScale = 1.5
--				g.map.overlay[x][y].yScale = 1.5
				g.map.overlay[x][y].isVisible = g.map.isVisible

				g.map.overlay[x][y]:setReferencePoint(display.CenterReferencePoint)
				g.imggroup:insert(g.map.overlay[x][y])
			end
		end
--]]

	--g.imggroup.isVisible = false
--	g.mob.player:toFront()

--	if (dbg) then dbg.devOut(direction) end


	--g.joystick.cursor:play()

--	g.cam.x = worldMap.xScroll
--	g.cam.y = worldMap.yScroll	

--[[
	if (g.screen.prevWorldX == g.cam.x and g.screen.prevWorldY == g.cam.y) then
	else
		g.screen.prevWorldX = g.cam.x
		g.screen.prevWorldY = g.cam.y
		--if (dbg) then dbg.out(thisFile, thisFunc, 'world.x, world.y '..worldMap.xScroll..' '..worldMap.yScroll..' TilesInView X,Y '..worldMap.xTilesInView..' '..worldMap.yTilesInView..' leftmost Tile, x,y '..math.floor(worldMap.xScroll/g.screen.pixelsPerTile)+1) end
		local playerTile = {}
		playerTile = myTile(g.mob.player.x, g.mob.player.y)
		local topLeftTile = {}
		topLeftTile = myTile(0,0)

		g.screen.xMinPhysicsRenderWindow = - 96 + g.screen.xMid
		g.screen.yMinPhysicsRenderWindow = - 96 + g.screen.yMid
		g.screen.xMaxPhysicsRenderWindow = 96 + g.screen.xMid
		g.screen.yMaxPhysicsRenderWindow = 96 + g.screen.yMid


		local topLeftTile = {}
		topLeftTile = myTile( g.screen.xMinPhysicsRenderWindow, g.screen.yMinPhysicsRenderWindow )

		local bottomRightTile = {}
		bottomRightTile = myTile( g.screen.xMaxPhysicsRenderWindow, g.screen.yMaxPhysicsRenderWindow )

		--if (dbg) then dbg.out(thisFile, thisFunc, 'PhysicsRenderWindow topLeft '..topLeftTile[1]..' '..topLeftTile[2]) end
		--if (dbg) then dbg.out(thisFile, thisFunc, 'PhysicsRenderWindow bottomRight '..bottomRightTile[1]..' '..bottomRightTile[2]) end

	end
--]]


--[[
	------------------------------------------ render viewable physics objects from the physicsArray


	------------------------------------------ frame length calculations for camera velocity
	g.cam.curTime = system.getTimer()
	g.cam.ticksPerFrame = g.cam.curTime - g.cam.prevTime

	--
		g.screen.pixelsPerTile = g.screen.tileSize
	--
	g.cam.pixelsPerFrame = g.cam.pixelsPerFrame + g.cam.velocity * g.screen.pixelsPerTile * g.cam.ticksPerFrame
	g.cam.pixelsPerFrame = g.cam.pixelsPerFrame + g.cam.velocity * g.screen.pixelsPerTile * g.cam.ticksPerFrame
	g.cam.pixelsPerFrameInt = math.floor(g.cam.pixelsPerFrame)
	g.cam.pixelsPerFrame = g.cam.pixelsPerFrame - g.cam.pixelsPerFrameInt
	g.cam.prevTime = g.cam.curTime
	--print(g.cam.pixelsPerFrame)

	g.cam.tdx = g.cam.pixelsPerFrameInt
	g.cam.tdy = g.cam.pixelsPerFrameInt

	------------------------------------------ how to move the screen based on camera properties
	if g.cam.tx > 0 then
		g.cam.tx = g.cam.tx - g.cam.tdx
		g.cam.x = g.cam.x + g.cam.tdx

		imgGroup.x = imgGroup.x - g.cam.tdx		
		g.mob.player.x = g.mob.player.x + g.cam.tdx

		if g.cam.tx < 0 then
			g.cam.x = g.cam.x - g.cam.tx
			--group.x = group.x + g.cam.tx
			--g.mob.player.x = g.mob.player.x - g.cam.tx
			g.cam.tx = 0
		end

	elseif g.cam.tx < 0 then
		g.cam.tx = g.cam.tx + g.cam.tdx
		g.cam.x = g.cam.x - g.cam.tdx
		imgGroup.x = imgGroup.x + g.cam.tdx
		g.mob.player.x = g.mob.player.x - g.cam.tdx

		if g.cam.tx > 0 then
			g.cam.x = g.cam.x - g.cam.tx
			--group.x = group.x + g.cam.tdx
			--g.mob.player.x = g.mob.player.x - g.cam.tdx
			g.cam.tx = 0
		end

	end

	------------------------------------------ how to move the screen based on camera properties
	if g.cam.ty > 0 then
		g.cam.ty = g.cam.ty - g.cam.tdy
		g.cam.y = g.cam.y + g.cam.tdy
		imgGroup.y = imgGroup.y - g.cam.tdy
		g.mob.player.y = g.mob.player.y + g.cam.tdy
		if g.cam.ty < 0 then
			g.cam.y = g.cam.y - g.cam.ty
			--group.y = group.y + g.cam.ty
			--g.mob.player.y = g.mob.player.y - g.cam.ty
			g.cam.ty = 0
		end

	elseif g.cam.ty < 0 then
		g.cam.ty = g.cam.ty + g.cam.tdy
		g.cam.y = g.cam.y - g.cam.tdy
		imgGroup.y = imgGroup.y + g.cam.tdy
		g.mob.player.y = g.mob.player.y - g.cam.tdy
		if g.cam.ty > 0 then
			g.cam.y = g.cam.y - g.cam.ty
			--group.y = group.y + g.cam.tdy
			--g.mob.player.y = g.mob.player.y - g.cam.tdy
			g.cam.ty = 0
		end

	end

	------------------------------------------
	if (g.cam.x < 0) then 
		g.cam.x = 0
		g.cam.tx = 0
	end

	if (g.cam.y < 0) then 
		g.cam.y = 0
		g.cam.ty = 0
	end

	if (g.cam.x > g.cam.xMax) then 
		g.cam.x = g.cam.xMax
		g.cam.tx = 0
	end

	if (g.cam.y > g.cam.yMax) then 
		g.cam.y = g.cam.yMax
		g.cam.ty = 0
	end

--	worldMap.xScroll = g.cam.x
--	worldMap.yScroll = g.cam.y

	--g.group.x = g.cam.x
	--g.group.y = g.cam.y

	--overlayMap.xScroll = g.cam.x
	--overlayMap.yScroll = g.cam.y
		print('break')
	

	------------------------------------------ draw the screen (aka the tilemaps)

--]]
	--g.updateDisplay()
end -- isEnterFrame
end -- onEnterFrame
--********************************************************************************************************
--******* onUpdate END
--********************************************************************************************************

function scene:enterScene( event )
	local thisFunc = 'enterScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end
	--Runtime:addEventListener( "collision", onCollision )	
	Runtime:addEventListener( 'enterFrame', onEnterFrame )
end
scene:addEventListener( 'enterScene', scene )

--****************************************************
function scene:exitScene( event )
	local thisFunc = 'exitScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end
	--Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener( 'enterFrame', onEnterFrame )
end
scene:addEventListener( 'exitScene', scene )

--****************************************************
function scene:didExitScene( event )
	local thisFunc = 'didExitScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end
end
scene:addEventListener( 'didExitScene', scene )

--****************************************************
return scene
