local thisFile = 'lib.level'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Level class
Level = {}

function Level.new(init)
	local self		= init

	self.file = require('levels.'..self.fileName) --'level1')
	self.width = self.file.width
	self.height = self.file.height

	-- 1d arrays
	self.underlayArray = self.file.layers[1].data
	self.overlayArray = self.file.layers[2].data
	self.physicsArray = self.file.layers[3].data

	-- 2d arrays
	self.underlay = {}
	self.overlay = {}
	self.physics = {}

	for x = 1, self.width do
		self.underlay[x] = {}
		self.overlay[x] = {}
		self.physics[x] = {}
		for y = 1, self.height do
			self.underlay[x][y] = self.underlayArray[x + (y-1) * self.width]
			self.overlay[x][y] = self.overlayArray[x + (y-1) * self.width]
			self.physics[x][y] = self.physicsArray[x + (y-1) * self.width]
		end
	end

	--****************************************************
	function self:showUnderlay()
		local thisFunc = 'showUnderlay()'
		dbg.out(thisFile,thisFunc, '')

		print('********* UNDERLAY')
		for y = 1, self.height do
			local s=''
			for x = 1, self.width do
				local spacer = ''
				if self.underlay[x][y] < 10 then
					spacer = ' '
				end
				s = s..spacer..self.underlay[x][y]..' '
			end
			print(s)
		end

	end

	--****************************************************
	function self:showOverlay()
		local thisFunc = 'showOverlay()'
		dbg.out(thisFile,thisFunc, '')

		print('********* OVERLAY')
		for y = 1, self.height do
			local s=''
			for x = 1, self.width do
				local spacer = ''
				if self.overlay[x][y] < 10 then
					spacer = ' '
				end
				s = s..spacer..self.overlay[x][y]..' '
			end
			print(s)
		end

	end


	--****************************************************
	function self:showPhysics()
		local thisFunc = 'showPhysics()'
		dbg.out(thisFile,thisFunc, '')

		print('********* PHYSICS')
		for y = 1, self.height do
			local s=''
			for x = 1, self.width do
				local spacer = ''
				if self.physics[x][y] < 10 then
					spacer = ' '
				end
				s = s..spacer..self.physics[x][y]..' '
			end
			print(s)
		end

	end

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, 'File: '..self.file)
	end

	--****************************************************

	return self



end