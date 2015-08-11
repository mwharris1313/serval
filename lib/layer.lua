local thisFile = g.dir.library..'layer'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--****************************************************
function vchToTileWidth(vch)
	local thisFunc = 'vchToTileWidth'
	if (dbg) then dbg.func(thisFile, thisFunc) end
	
	local tileWidth = nil

	if (vch <= 240) then
		tileWidth = 24
	elseif (vch > 240 and vch <= 320) then
		tileWidth = 32
	elseif (vch > 320 and vch <= 480) then
		tileWidth = 48
	elseif (vch > 480 and vch <= 640) then
		tileWidth = 58
	elseif (vch > 640 and vch <= 800 ) then
		tileWidth = 76
	elseif (vch > 800 and vch <= 1200) then
		tileWidth = 120
	elseif (vch > 1200 and vch <=1600) then
		tileWidth = 156
	elseif (vch > 1600) then
		tileWidth = 156
	end

	return tileWidth
end

--****************************************************
function initImageSheet(filePrefix, tilesInSheet)
	local thisFunc = 'initImageSheet'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	local tileWidth = 32--vchToTileWidth(display.viewableContentHeight)
	local imgSheet = {}
	imgSheet = graphics.newImageSheet( g.screen.imgSheet, { width = g.screen.pixelsPerTile, height = g.screen.pixelsPerTile, numFrames = g.screen.tilesPerSheet, } )

	return imgSheet
end

--****************************************************
function initMap(imgSheet, levelWidth, levelHeight)
	local thisFunc = 'initMap'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	local map = display.newImageGroup(imgSheet)
	map.tiles = {}
	map.xTiles = levelWidth
	map.yTiles = levelHeight
	map.tileWidth = vchToTileWidth(display.viewableContentHeight)
	map.tileHeight = vchToTileWidth(display.viewableContentHeight)
	map.xTilesInView = math.ceil((display.viewableContentWidth - 1) / map.tileWidth) + 1
	map.yTilesInView = math.ceil((display.viewableContentHeight - 1) / map.tileHeight) + 1
	if (dbg) then dbg.out(thisFile, thisFunc, 'map.xTilesInView, map.yTilesInView '..map.xTilesInView..' '..map.yTilesInView ) end
	map.xCam = 0	-- camera center x
	map.yCam = 0	-- camera center y
	map.leftCam = display.viewableContentWidth / 2	-- camera left x value
	map.topCam = display.viewableContentHeight / 2	-- caera top y value
	return map
end

--****************************************************
--populate the group with just enough objects to cover the entire screen
function initScreen()
	local thisFunc = 'initScreen'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	local i = 1
	for y = 0, g.screen.yTilesInView - 1 do
		for x = 0, g.screen.xTilesInView - 1 do
			i = i + 1
			local tile = display.newSprite( g.imgsheet[1],  { name=''..x..y, start=1, count=g.screen.tilesPerSheet, time=0 })  
			tile:setReferencePoint(display.TopLeftReferencePoint)
			tile.x = x * g.screen.pixelsPerTile
			tile.y = y * g.screen.pixelsPerTile
			tile.isVisible = false
			g.imggroup:insert(tile)	   
			--g.imgGroup:insert(tile)	   
		end
	end
end

--****************************************************
function updateDisplay(map, levelData,map2,levelData2)
	--local thisFunc = 'updateDisplay'
	--if (dbg) then dbg.func(thisFile, thisFunc) end

	g.imggroup.x = -(g.cam.x % g.screen.pixelsPerTile)
	g.imggroup.y = -(g.cam.y % g.screen.pixelsPerTile)

	--map2.x = -(map2.xScroll % map2.tileWidth)
	--map2.y = -(map2.yScroll % map2.tileHeight)

	-----------------------------------------------------------
	-- forTilesInView
	for y = 0, g.screen.yTilesInView - 1 do
		for x = 0, g.screen.xTilesInView - 1 do

			local tx = math.floor((g.cam.x - 0*g.cam.x) / g.screen.pixelsPerTile) + x;
			local ty = math.floor((g.cam.y - 0*g.cam.y) / g.screen.pixelsPerTile) + y;
			local t = g.imggroup[g.screen.xTilesInView * y + x + 1]
			--local t2 = map2[map2.xTilesInView * y + x + 1]

			-----------------------------------------------------------
			-- visTest
			if (tx >= 0 and tx < map.xTiles and y >= 0 and ty < map.yTiles) then
				-- tile is inside the map
				t.isVisible = true
				--t2.isVisible = true
				if (levelData.layers[1].data[ty * map.xTiles + tx + 1] == 0) then
				else
					t:setFrame(levelData.layers[1].data[ty * map.xTiles + tx + 1])
					
				end
				
				--if (levelData2.layers[2].data[ty * map2.xTiles + tx + 1] == 0) then
				--	t2:setFrame(1)
				--else
				--	if (levelData2.layers[2].data[ty * map2.xTiles + tx + 1] > g.screen.tilesPerSheet) then
				--		t2:setFrame(levelData2.layers[2].data[ty * map2.xTiles + tx + 1] - g.screen.tilesPerSheet)
				--	else
				--		t2:setFrame(levelData2.layers[2].data[ty * map2.xTiles + tx + 1])
				--	end
				--end

			else
				t.isVisible = false -- tile is off the edge of the map
				--t2.isVisible = false -- tile is off the edge of the map
			end
			-----------------------------------------------------------

		end
	end
	-----------------------------------------------------------
end



--****************************************************
-- load map from level file)
function loadMap(map,levelData, fLayerIndex)
	local thisFunc = 'loadMap'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	local i = 0
	for y = 0, g.screen.worldHeightInTiles - 1 do
	        for x = 0, g.screen.worldWidthInTiles - 1 do
	        	i = i + 1
	        	if (levelData.layers[fLayerIndex].data[i] == 0) then
		        	g.imggroup[i] = 1 --math.random(g.screen.tilesPerSheet)	        	
	        	else
		        	g.imggroup[i] = levelData.layers[fLayerIndex].data[i]
	        	end
	        end
	end
end

--****************************************************
