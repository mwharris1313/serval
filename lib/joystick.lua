local thisFile = 'lib.joystick'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Joystick class
Joystick = {}

function Joystick.new(init)
	local self		= init

	--------------------------------------------------------------------------------------------------
		-- self.cursor = display.newImageRect( self.dir.image..'cursor32.png', 64, 64 )

		self.cursor = {}
		-- self.cursor = display.newSprite( g.mob[g.mob.NOMSY].imgsheet, g.mob[g.mob.NOMSY].seqData)
		self.cursor = display.newRect(0, 0, 40, 40)
		self.cursor.isVisible = false

		self.cursor.strokeWidth = 3
		self.cursor:setFillColor(140, 140, 140)
		self.cursor:setStrokeColor(180, 180, 180)

		self.cursor:setReferencePoint(display.CenterReferencePoint)
		self.cursor.x = display.viewableContentWidth / 2 - 40
		self.cursor.y = display.viewableContentHeight / 2 -40
		self.cursor.xScale = 1
		self.cursor.yScale = 1

		-- self.cursor:setSequence('down')
		-- self.cursor:play()
		
		-- g.mobgroup = display.newGroup()		
		-- self.cursor:toFront()
		
		-- self.cursor:toFront()
	--------------------------------------------------------------------------------------------------
		self.dxCenter = 0 -- x distance from center of screen for tap-event
		self.dyCenter = 0 -- y distance from center of screen for tap-event
	--------------------------------------------------------------------------------------------------
		self.xPrev = 0
		self.yPrev = 0
		self.xCur = 0
		self.yCur = 0
		self.dx = 0
		self.dy = 0
		self.dxPrev = 0
		self.dyPrev = 0
		self.threshold = 1

	--****************************************************
	function self:out()
		local thisFunc = 'out()'
		dbg.out(thisFile,thisFunc, 'Joystick: ')

	end

	--****************************************************

	return self

end