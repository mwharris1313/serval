local thisFile = 'lib.imgsheet'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- ImgSheet class
ImgSheet = {}

function ImgSheet.new(init)
	local self		= init
	--if self.current == nil then self.current = 64 end
	--	if self.tilesPerSheet == nil	then self.tilesPerSheet = 625 end
	if self.tilesPerSheet == nil	then self.tilesPerSheet = 256 end
	--	if self.tileSizes == nil 		then self.tileSizes = {160,128,96,80,64,48,40,32,24,20,16,12} end
	if self.tileSizes == nil 		then self.tileSizes = {128,96,80,64,48,40,32,24,20,16} end
	if self.tileSize == nil			then self.tileSize = 64 end
	if self.transparentTile == nil	then self.transparentTile = 256 end

	self.tilesPerSheet = 256
	self.tileSizesAvailable =	{}
	--	self.tileSizesAvailable =	{160,128,96,80,64,48,40,32,24,20,16,12}
	self.tileSizesAvailable =	{128,96,80,64,48,40,32,24,20,16}
	--	self.tileSizesAvailable =	{128,96,80,64,56,48,40,32,24,20,16}

	local tmem = system.getInfo("maxTextureSize")
	if (tmem >= 4096) then 
		self.tileSizesAvailable =	{160,128,96,80,64,48,40,32,24,20,16,12}
	elseif (tmem >= 2048 and tmem < 4096 ) then
		self.tileSizesAvailable =	{80,64,48,40,32,24,20,16,12}
	elseif (tmem >= 1024 and tmem < 2048 ) then
		self.tileSizesAvailable =	{40,32,24,20,16,12}
	end

	self.current = {}

	--****************************************************
	function self:setTileSize(fTileSize)
		local thisFunc = 'setTileSize()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		self.tileSize = fTileSize
		-- self.current = graphics.newImageSheet( 'img/sheet'..fTileSize..'.png', { width = fTileSize, height = fTileSize, numFrames = self.tilesPerSheet,  sheetContentWidth = 4000, sheetContentHeight = 4000} )
		self.current = graphics.newImageSheet( 'img/sheet'..fTileSize..'.png', { width = fTileSize, height = fTileSize, numFrames = self.tilesPerSheet, } )
	end	

	--****************************************************
	function self:delete()
		local thisFunc = 'delete()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end
		display.remove(g.imgsheet.current)
		g.imgsheet.current = nil
	end


	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		if (dbg) then dbg.out(thisFile,thisFunc, '') end

	end

	--****************************************************

	self:setTileSize(self.tileSize)
	return self

end