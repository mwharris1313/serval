local thisFile = 'createRoom'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
-- setup storyboard


--****************************************************

local scene = sb.newScene()

-- forward declarations
local object1, object2
local roomID
--local input
local gText
--****************************************************
-- enterFrame event listener function
local function onUpdate( event )
	--local thisFunc = 'onUpdate'
	--if (dbg) then dbg.func(thisFile, thisFunc) end

    -- do something here
end

--****************************************************
-- enterFrame event listener function
local function onInput(e)
	local thisFunc = 'onInput'
	if (dbg) then dbg.func(thisFile, thisFunc) end
		if e.text ~= nil then
			gText = e.text
		end
	if e.phase == 'submitted' then --or e.phase == 'ended' then
		if (dbg) then dbg.out(thisFile, thisFunc, 'input submitted or ended') end
		db.updateConfig('userName',gText)
		pn.pnObj.uuid = db.getConfigColumn('userName')..'_'..db.getConfigColumn('uuid')
	end
end

--****************************************************
function scene:createScene( event )
	local thisFunc = 'createScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	--sb.purgeAll()
    local group = self.view

	    bg = display.newImage( 'Icon-72.png' )
	    bg:setReferencePoint( display.TopLeftReferencePoint )
	    bg.x = 0
	    bg.y = 0
	    bg.width = 200
		group:insert( bg )

local widget = require 'widget'

local onButtonEvent = function (e)
    if e.phase == 'release' then
        if (e.target.id == 'start') then
        	if (dbg) then dbg.out(thisFile, thisFunc, 'save button pressed') end
        	pn.disconnect()
        	roomID:removeSelf()
			sb.gotoScene('startMenu')
        end
    end
end

local xCenter = display.viewableContentWidth/2
local button1 = widget.newButton{
    id = 'start',
    left = 20,
    top = 120,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button1:setLabel( 'Start' )
group:insert( button1 )  -- if using older build, use: myButton.view instead

--------------------------------------------------------------------------------------------------
end
scene:addEventListener( 'createScene', scene )

--****************************************************
function scene:willEnterScene( event )
	local thisFunc = 'willEnterScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end
	
    --object1.isVisible = false
    --object2.isVisible = false
end
scene:addEventListener( 'willEnterScene', scene )

--****************************************************
function scene:enterScene( event )
	local thisFunc = 'enterScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	gText = ''
	pn.isRoomCreator = true
	pn.disconnect()
	pn.curChannel = pn.createRoomID()
	pn.connect()
	
	
	    local group = self.view



		local blankOut = display.newRect(20, 80, 150, 50)
		blankOut.strokeWidth = 3
		blankOut:setFillColor(140, 140, 140)
		blankOut:setStrokeColor(180, 180, 180)		
	    blankOut:setReferencePoint( display.TopLeftReferencePoint )
		group:insert( blankOut )


		roomID = display.newText('Room Code: '..pn.curChannel, 20, 80, native.systemFont, 16)
		roomID:setTextColor(255, 255, 255)
		--roomID.width = 200
		--roomID.height = 80
	    roomID:setReferencePoint( display.TopLeftReferencePoint )
		group:insert( roomID )
	
    Runtime:addEventListener( 'enterFrame', onUpdate )
end
scene:addEventListener( 'enterScene', scene )

--****************************************************
function scene:exitScene( event )
	local thisFunc = 'exitScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end

    --object1.isVisible = true
    --object2.isVisible = true

	--Runtime:removeEventListener('touch', drag)
    Runtime:removeEventListener( 'enterFrame', onUpdate )
	
end
scene:addEventListener( 'exitScene', scene )

--****************************************************
function scene:didExitScene( event )
	local thisFunc = 'didExitScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end

    dbg.out(thisFile, thisFunc, 'This scene has fully transitioned out and is no longer the active scene.' )
end
scene:addEventListener( 'didExitScene', scene )

--****************************************************

return scene

