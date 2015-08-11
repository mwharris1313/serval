local thisFile = 'joinRoom'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
-- setup storyboard


--****************************************************

local scene = sb.newScene()

-- forward declarations
local object1, object2
local input
local gText
local button1
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
	if e.phase == 'submitted' or e.phase == 'ended' then
		if (dbg) then dbg.out(thisFile, thisFunc, 'input submitted or ended') end
		pn.disconnect()
		pn.curChannel = gText
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
		group:insert( bg )



local widget = require 'widget'

local onButtonEvent = function (e)
    if e.phase == 'release' then
        if (e.target.id == 'join') then
        	if (dbg) then dbg.out(thisFile, thisFunc, 'save button pressed') end
        	input:removeSelf()
        	button1.isVisible = false
        	pn.connect()
        	pn.send('joinRoom', 'dummyData')
			--sb.gotoScene('startMenu')
        elseif (e.target.id == 'back') then
        	if (dbg) then dbg.out(thisFile, thisFunc, 'save button pressed') end
        	--input:removeSelf()
        	pn.disconnect()
			sb.gotoScene('startMenu')
        end
    end
end

local xCenter = display.viewableContentWidth/2
button1 = widget.newButton{
    id = 'join',
    left = 20,
    top = 120,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button1:setLabel( 'Join' )
group:insert( button1 )  -- if using older build, use: myButton.view instead

local button2 = widget.newButton{
    id = 'back',
    left = 180,
    top = 120,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button2:setLabel( 'Back' )
group:insert( button2 )  -- if using older build, use: myButton.view instead





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

	input = native.newTextField( 20, 80, 220, 36, onInput )
	input.inputType = 'default'
	input.text = ''
	button1.isVisible = true
    --object1.isVisible = true
    --object2.isVisible = true

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

