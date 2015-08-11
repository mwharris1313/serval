local thisFile = g.dir.main..'startMenu'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
-- setup storyboard

--****************************************************

local scene = sb.newScene()

-- forward declarations
local object1, object2

--****************************************************
-- enterFrame event listener function
local function onUpdate( event )
	--local thisFunc = 'onUpdate'
	--if (dbg) then dbg.func(thisFile, thisFunc) end

    -- do something here
end

--****************************************************
function scene:createScene( event )
	local thisFunc = 'createScene'
	if (dbg) then dbg.func(thisFile, thisFunc) end

	--sb.purgeAll()
    local group = self.view

	    bg = display.newImage( 'Icon.png' )
	    bg:setReferencePoint( display.TopLeftReferencePoint )
	    bg.x = 0
	    bg.y = 0
		group:insert( bg )

local widget = require 'widget'

local onButtonEvent = function (e)
    if e.phase == 'release' then
        if (e.target.id == 'startGame') then sb.gotoScene(g.dir.main..'levelLoader') end
        if (e.target.id == 'findBattle') then sb.gotoScene(g.dir.network..'findBattle') end
        if (e.target.id == 'createRoom') then sb.gotoScene(g.dir.network..'createRoom') end
        if (e.target.id == 'joinRoom') then sb.gotoScene(g.dir.network..'joinRoom') end
        if (e.target.id == 'editName') then sb.gotoScene(g.dir.network..'editName') end
    end
end

local xCenter = display.viewableContentWidth/2
local button0 = widget.newButton{
    id = 'startGame',
    left = 20,
    top = 80,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button0:setLabel( 'v'..g.ver )
group:insert( button0 )  -- if using older build, use: myButton.view instead

local button1 = widget.newButton{
    id = 'findBattle',
    left = 20,
    top = 120,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button1:setLabel( 'Find Battle' )
group:insert( button1 )  -- if using older build, use: myButton.view instead

local button2 = widget.newButton{
    id = 'createRoom',
    left = 20,
    top = 160,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button2:setLabel( 'Create Meeting Room' )
group:insert( button2 )  -- if using older build, use: myButton.view instead

local button3 = widget.newButton{
    id = 'joinRoom',
    left = 20,
    top = 200,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button3:setLabel( 'Join Meeting Room' )
group:insert( button3 )  -- if using older build, use: myButton.view instead

local button4 = widget.newButton{
    id = 'editName',
    left = 20,
    top = 240,
    label = 'Widget Button',
    width = 150, height = 28,
    cornerRadius = 8,
    onEvent = onButtonEvent
}
button4:setLabel( 'Edit Screen Name' )
group:insert( button4 )  -- if using older build, use: myButton.view instead

--[[
	local function drag(event)
		local thisFunc = 'drag'
		--if (dbg) then dbg.func('drag') end

        --if event.phase == 'began' then
                
        --elseif event.phase == 'moved' then
         
        --elseif event.phase == 'ended' then
        if event.phase == 'ended' then
        	
			sb.gotoScene('editName' )
        	
		end
        
	end

	Runtime:addEventListener('touch', drag)
--]]
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
