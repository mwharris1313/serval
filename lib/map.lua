local thisFile = 'lib.map'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Map class
Map = {}

function Map.new(init)
	local self		= init

	self.isVisible = true
	self.height = 1 + math.ceil(g.screen.height / g.imgsheet.tileSize)
	self.width = 1 + math.ceil(g.screen.width / g.imgsheet.tileSize) 

	self.x = 0
	self.y = 0
	
	-- 2d arrays
	self.underlayArray = {}
	self.overlayArray = {}
	self.physicsArray = {}

	-- 2d display arrays
	self.underlay = {}
	self.overlay = {}
	self.physics = {}

	local transparentTile = 256
	
	for x = 1, self.width do
		self.underlayArray[x] = {}
		self.overlayArray[x] = {}
		self.physicsArray[x] = {}
		for y = 1, self.height do
			self.underlayArray[x][y] = g.level.underlay[self.x + x][self.y + y]
			self.overlayArray[x][y] = g.level.overlay[self.x + x][self.y + y]
			self.physicsArray[x][y] = g.level.physics[self.x + x][self.y + y]
		end
	end

--[[
	print('********* underlay Array')
	for y = 1, self.height do
		local s=''
		for x = 1, self.width do
			local spacer = ''
			if self.underlayArray[x][y] < 10 then
				spacer = ' '
			end
			s = s..spacer..self.underlayArray[x][y]..' '
		end
		print(s)
	end

	print('********* overlay Array')
	for y = 1, self.height do
		local s=''
		for x = 1, self.width do
			local spacer = ''
			if self.overlayArray[x][y] < 10 then
				spacer = ' '
			end
			s = s..spacer..self.overlayArray[x][y]..' '
		end
		print(s)
	end

	print('********* physics Array')
	for y = 1, self.height do
		local s=''
		for x = 1, self.width do
			local spacer = ''
			if self.physicsArray[x][y] < 10 then
				spacer = ' '
			end
			s = s..spacer..self.physicsArray[x][y]..' '
		end
		print(s)
	end
--]]

			--[[

	print('********* underlay')
	for y = 1, self.height do
		for x = 1, self.width do
			local tile = display.newSprite( g.imgsheet[1],  { name=''..x..y, start=1, count=g.screen.tilesPerSheet, time=0 })  
			tile:setReferencePoint(display.TopLeftReferencePoint)
			tile.x = x * g.screen.pixelsPerTile
			tile.y = y * g.screen.pixelsPerTile
			tile.isVisible = false
			g.imggroup:insert(tile)	   
			--g.imgGroup:insert(tile)	
		end
	end
			--]]

	for x = 1, self.width do
		self.underlay[x] = {}
		for y = 1, self.height do
--			self.underlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=g.level.underlay[x][y], count=1, time=0 })
			self.underlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=1, count=256, time=0 })
			self.underlay[x][y]:setFrame(256)

			self.underlay[x][y].x = x * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
			self.underlay[x][y].y = y * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
			self.underlay[x][y].width = g.imgsheet.tileSize -- / g.screen.tileScale
			self.underlay[x][y].height = g.imgsheet.tileSize -- / g.screen.tileScale			
			self.underlay[x][y]:setReferencePoint(display.CenterReferencePoint);
			g.imggroup:insert(self.underlay[x][y])
		end
	end

	for x = 1, self.width do
		self.overlay[x] = {}
		for y = 1, self.height do
			print(x,',',y,' g.level.overlay[x][y]',g.level.overlay[x][y])
			-- local tile = g.level.overlay[x][y]
			-- if tile == 0 then tile = g.imgsheet.transparentTile end
			-- self.overlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=tile, count=1, time=0 })
			self.overlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=1, count=256, time=0 })
			self.overlay[x][y]:setFrame(256)
			
			self.overlay[x][y].x = x * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
			self.overlay[x][y].y = y * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
			self.overlay[x][y].width = g.imgsheet.tileSize
			self.overlay[x][y].height = g.imgsheet.tileSize			
			self.overlay[x][y]:setReferencePoint(display.CenterReferencePoint);
			g.imggroup:insert(self.overlay[x][y])
		end
	end

--[[
	for x = 1, self.width do
		self.overlay[x] = {}
		for y = 1, self.height do
			local startFrame = g.screen.tilesPerSheet
			if g.level.overlay[x][y] ~= 0 then startFrame = g.level.overlay[x][y] end
			self.overlay[x][y] = display.newSprite( g.imgsheet[g.imgsheet.current],  { name=''..x..y, start=startFrame, count=g.imgsheet.tilesPerSheet-1, time=0 })
			self.overlay[x][y].x = x * g.screen.tileSize - g.screen.tileSize / 2
			self.overlay[x][y].y = y * g.screen.tileSize - g.screen.tileSize / 2
			self.overlay[x][y].width = g.screen.tileSize
			self.overlay[x][y].height = g.screen.tileSize
			--self.map.overlay[x][y].xScale = 1--self.screen.tileSize
			--self.map.overlay[x][y].yScale = 1--self.screen.tileSize
			self.overlay[x][y]:setReferencePoint(display.CenterReferencePoint);
			g.imggroup:insert(self.overlay[x][y])
		end
	end

	for x = 1, self.map.width do
		self.map.physics[x] = {}
		for y = 1, self.map.height do
			self.map.physics[x][y] = display.newSprite( self.level.imgSheet,  { name=''..x..y, start=self.level.physics[x][y], count=self.screen.tilesPerSheet, time=0 })
			self.map.physics[x][y].x = x * self.screen.tileSize - self.screen.tileSize / 2
			self.map.physics[x][y].y = y * self.screen.tileSize - self.screen.tileSize / 2
			self.map.physics[x][y].width = self.screen.tileSize
			self.map.physics[x][y].height = self.screen.tileSize
			--self.map.physics[x][y].xScale = 1--self.screen.tileSize
			--self.map.physics[x][y].yScale = 1--self.screen.tileSize
			self.map.physics[x][y]:setReferencePoint(display.CenterReferencePoint);
			self.group:insert(self.map.physics[x][y])
		end
	end
--]]

	--****************************************************
	function self:create()
		local thisFunc = 'create()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

		self.height = 1 + math.ceil(g.screen.height / g.imgsheet.tileSize)
		self.width = 1 + math.ceil(g.screen.width / g.imgsheet.tileSize) 

		self.x = 0
		self.y = 0

		-- 2d arrays
		-- self.underlayArray = {}
		-- self.overlayArray = {}
		-- self.physicsArray = {}

		-- 2d display arrays
		self.underlay = {}
		self.overlay = {}
		self.physics = {}

		for x = 1, self.width do
			self.underlayArray[x] = {}
			self.overlayArray[x] = {}
			self.physicsArray[x] = {}
			for y = 1, self.height do
				self.underlayArray[x][y] = g.level.underlay[self.x + x][self.y + y]
				self.overlayArray[x][y] = g.level.overlay[self.x + x][self.y + y]
				self.physicsArray[x][y] = g.level.physics[self.x + x][self.y + y]
			end
		end

		for x = 1, self.width  do
			self.underlay[x] = {}
			for y = 1, self.height do
				-- self.underlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=g.level.underlay[x][y], count=1, time=0 })
				self.underlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=1, count=256, time=0 })
				self.underlay[x][y]:setFrame(256)
				
				self.underlay[x][y].x = x * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				self.underlay[x][y].y = y * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				self.underlay[x][y].width = g.imgsheet.tileSize -- / g.screen.tileScale
				self.underlay[x][y].height = g.imgsheet.tileSize -- / g.screen.tileScale	
				self.underlay[x][y].isVisible = self.isVisible

				-- self.underlay[x][y]:setFrame(g.level.underlay[x][y])

				self.underlay[x][y]:setReferencePoint(display.CenterReferencePoint);
				g.imggroup:insert(self.underlay[x][y])
			end
		end

		for x = 1, self.width do
			self.overlay[x] = {}
			for y = 1, self.height do
				print(x,',',y,' g.level.overlay[x][y]',g.level.overlay[x][y])
				local tile = g.level.overlay[x][y]
				-- if tile == 0 then tile = g.imgsheet.transparentTile end
				-- self.overlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=tile, count=1, time=0 })
				self.overlay[x][y] = display.newSprite( g.imgsheet.current,  { name=x..'x'..y, start=1, count=256, time=0 })
				self.overlay[x][y]:setFrame(256)

				-- self.overlay[x][y]:setFrame(tile)
 

				self.overlay[x][y].x = x * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				self.overlay[x][y].y = y * g.imgsheet.tileSize - g.imgsheet.tileSize / 2
				self.overlay[x][y].width = g.imgsheet.tileSize
				self.overlay[x][y].height = g.imgsheet.tileSize
				-- self.overlay[x][y].xScale = 1.5
				-- self.overlay[x][y].yScale = 1.5
				self.overlay[x][y].isVisible = self.isVisible

				-- self.overlay[x][y]:setFrame(g.level.overlay[x][y])

				self.overlay[x][y]:setReferencePoint(display.CenterReferencePoint)
				g.imggroup:insert(self.overlay[x][y])
			end
		end

	end

	--****************************************************
	function self:delete()
		local thisFunc = 'delete()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

		for x = 1, g.map.width do
			for y = 1, g.map.height do
				display.remove(g.map.overlay[x][y])
				g.map.overlay[x][y] = nil
				display.remove(g.map.underlay[x][y])				
				g.map.underlay[x][y] = nil
			end
		end

	end

	--****************************************************
	function self:render()
		local thisFunc = 'render()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

		for x = 1, self.width do
			for y = 1, self.height do

				local overlayCur = g.level.overlay[x][y]
				local underlayCur = g.level.underlay[x][y]

				local overlayPrev = self.overlay[x][y].frame
				local underlayPrev = self.underlay[x][y].frame

				if (overlayCur ~= overlayPrev) then
					self.overlay[x][y]:setFrame(overlayCur)
				end

				if (underlayCur ~= underlayPrev) then
					self.underlay[x][y]:setFrame(underlayCur)
				end

			end
		end

	end

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

	end

	--****************************************************

	return self

end