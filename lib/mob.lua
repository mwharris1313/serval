local thisFile = 'lib.mob'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Mob class
Mob = {}

function Mob.new(init)
	local self		= init

	self.NOMSY = 1
	--------------------------------------------------------------------------------------------------
	self[self.NOMSY] = {}

--*******************************************************************

-- this line kills all local group and sprites from displaying , why???
-- BUGFIX, because Corona doesn't like high width imgsheets, use more squarish imgsheets not long chain of frames.
	self[self.NOMSY].imgsheet = graphics.newImageSheet( 'img/nomsy'..g.imgsheet.tileSize..'.png', { width = g.imgsheet.tileSize, height = g.imgsheet.tileSize, numFrames = 32, } )
--	self[self.NOMSY].imgsheet = graphics.newImageSheet( 'img/nomsy80.png', { width = 80, height = 80, numFrames = 32, } )

--*******************************************************************

	self[self.NOMSY].seqData = {}
	self[self.NOMSY].seqData = {
		{name='up',frames={1,2,3,4,5,6,7,8,},time=300,loopCount = 0,loopDirection = 'bounce'},
		{name='down',frames={9,10,11,12,13,14,15,16,},time=300,loopCount = 0,loopDirection = 'bounce'},
		{name='left',frames={1,2,3,4,5,6,7,8,},time=300,loopCount = 0,loopDirection = 'bounce'},
		{name='right',frames={9,10,11,12,13,14,15,16,},time=300,loopCount = 0,loopDirection = 'bounce'},
	}

		self.player = {}
		self.player = display.newSprite( self[self.NOMSY].imgsheet, self[self.NOMSY].seqData)
		self.player:setReferencePoint(display.CenterReferencePoint)
		self.player.x = display.viewableContentWidth / 2
		self.player.y = display.viewableContentHeight / 2
		self.player.xScale = 1
		self.player.yScale = 1
		self.player.isVisible = false
		
		self.player:setSequence('down')
		self.player:play()
		
--		g.mobgroup:insert(self.player)
--		self.player:toFront()
--		g.mob.player:toFront()

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, 'Mob: ')

	end

	--****************************************************

	return self

end