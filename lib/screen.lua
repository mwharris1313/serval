local thisFile = 'lib.screen'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Screen class
Screen = {}

function Screen.new(init)
	local self		= init

	if self.heightInTiles == nil	then self.heightInTiles = 10 end

	self.width = display.viewableContentWidth
	self.height = display.viewableContentHeight
	self.maxTextureSize =  system.getInfo("maxTextureSize")

	--****************************************************
	function self:setHeightInTiles(fHeightInTiles)
		local thisFunc = 'setHeightInTiles()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

		local size10Min = 0
		local size10Max = 0
		local deltaMin = 0
		local deltaMax = 0
		---------------------------------------------
		for i=1,#g.imgsheet.tileSizes do
			local tileSize = g.imgsheet.tileSizes[i]
			
			if (math.ceil(self.height/tileSize) <= fHeightInTiles ) then
				size10Min = tileSize
				
				deltaMin = fHeightInTiles - math.ceil(self.height/tileSize)
			end
			
			if (math.ceil(self.height/tileSize) > fHeightInTiles ) then
				size10Max = tileSize
				deltaMax = math.ceil(self.height/tileSize) - fHeightInTiles
				break
			end

		end

		---------------------------------------------
		if deltaMin <= deltaMax then
			self.tileSize = size10Min
		else
			self.tileSize = size10Max
		end

		---------------------------------------------

	end
		
	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, '')
	end

	--****************************************************

	self:setHeightInTiles(self.heightInTiles)
	return self

end