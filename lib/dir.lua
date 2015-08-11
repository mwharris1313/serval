local thisFile = 'lib.dir'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Dir class
Dir = {}

function Dir.new(init)
	local self		= init

	self.image		= 'img/'
	self.library	= 'lib.'
	self.main			= 'main.'
	self.network	= 'net.'
	self.tileMap	= 'tileMaps.'

	function self:out()
		local thisFunc = 'out()'
		if (dbg) then
			dbg.out(thisFile,thisFunc, 'Dir: ')
			dbg.out(thisFile,thisFunc, 'image '..self.image)
			dbg.out(thisFile,thisFunc, 'library '..self.library)
			dbg.out(thisFile,thisFunc, 'main '..self.main)
			dbg.out(thisFile,thisFunc, 'network '..self.network)
			dbg.out(thisFile,thisFunc, 'tileMap '..self.tileMap)
		end
	end

	return self

end