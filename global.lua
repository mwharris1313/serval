local thisFile = 'global'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
require 'lib.dir'
require 'lib.level'
require 'lib.screen'
require 'lib.map'
require 'lib.cam'
require 'lib.mob'
require 'lib.joystick'
require 'lib.imgsheet'
--------------------------------------------------------------------------------------------------
-- Global class
Global = {}
--************************************************************************************************
-- constructor
function Global:new(parm)

	--------------------------------------------------------------------------------------------------
	local self = {}
		self.isRunning = true
		self.dbgFile = true
		self.dbgFunc = true
		self.appName = "nomsy"
		self.ver = 'YYYYMMMDDTTHHMM'
		self.buildFor = 'android' -- options: all, ios, android, kindle, nook
	--------------------------------------------------------------------------------------------------

	self.dir = Dir.new({})
	self.dir:out()
	--------------------------------------------------------------------------------------------------
	self.dbg = {}
	self.dbg.prevTime = system.getTimer()
	--------------------------------------------------------------------------------------------------
	self.isEnterFrame = false
	--------------------------------------------------------------------------------------------------
	self.level = {}
	self.screen = {}
	self.map = {}
	self.group = {}
	self.cam = {}
	self.imgsheet = {}
	self.imggroup = {}
	self.mob = {}
	self.joystick = {}
	self.mobgroup = {}
	--------------------------------------------------------------------------------------------------
	
	--****************************************************
	function self:createImgGroupAndSheet()
		local thisFunc = 'createImgGroupAndSheet()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		g.imgsheet = ImgSheet.new({ tilesPerSheet=256, tileSizes={128,96,80,64,48,40,32,24,20,16} })
		g.imggroup = display.newImageGroup( g.imgsheet.current )
		g.imggroup.isVisible = true
	end
	
	--****************************************************
	function self:changeImgGroupAndSheet(fTileSize)
		local thisFunc = 'createImgGroupAndSheet()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		g.imgsheet.tileSize = fTileSize
		g.imgsheet.current = graphics.newImageSheet( 'img/sheet'..fTileSize..'.png', { width = fTileSize, height = fTileSize, numFrames = 256, } )
		g.imggroup = display.newImageGroup( g.imgsheet.current )
		g.imggroup.isVisible = false
	end
	
	--****************************************************
	function self:deleteImgGroupAndSheet()
		local thisFunc = 'deleteImgGroupAndSheet()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		if g.imggroup.numChildren > 0 then
			for i=g.imggroup.numChildren,1,-1 do
				g.imggroup[i]:removeSelf()
				g.imggroup[i] = nil
			end
		end
		g.imggroup = nil
		g.imgsheet.current = nil
	end

	--****************************************************
	function self:collectGarbage()
		local thisFunc = 'collectGarbage()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		collectgarbage()
	end

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, '')
	end

	--****************************************************

--[[
	--------------------------------------------------------------------------------------------------
	self.hud = {} -- heads up display
		self.hud.xCrosshair = display.newRect(self.screen.xMid, 0, 1, self.screen.height)
		self.hud.xCrosshair:setFillColor(255, 255, 255)
		self.hud.xCrosshair.isVisible = false
		self.hud.yCrosshair = display.newRect(0, self.screen.yMid, self.screen.width, 1)
		self.hud.yCrosshair:setFillColor(255, 255, 255)
		self.hud.yCrosshair.isVisible = false

		self.hud.grid = {}
		local n = 1
		-- vertical bars
		for i = 1, self.screen.xTilesInView do
			self.hud.grid[n] = display.newRect(self.screen.xMid, 0, 1, self.screen.height)
			n = n + 1
		end
		-- horizontal bars
		for i = 1, self.screen.yTilesInView do
			self.hud.grid[n] = display.newRect(0, self.screen.yMid, 1, self.screen.width)
			n = n + 1
		end

--]]



--****************************************************
	--self.updateDisplay = function ()

--		print("UPDATING")

--[[
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
--]]
	--end


	return self
end


local instance = Global:new({})

return instance