local thisFile = g.dir.main..'startScreen'
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

	sb.purgeAll()
    local group = self.view

	    bg = display.newImage( 'Icon.png' )
	    bg:setReferencePoint( display.CenterReferencePoint )
	    bg.x = display.viewableContentWidth/2
	    bg.y = display.viewableContentHeight/2
	    bg.width = display.viewableContentWidth - 50
	    bg.height = display.viewableContentHeight - 50
		group:insert( bg )

--------------------------------------------------------------------------------------------------

--move tile map
local function drag(event)
	local thisFunc = 'drag'
	--if (dbg) then dbg.func('drag') end

        --if event.phase == 'began' then
                
        --elseif event.phase == 'moved' then
         
        --elseif event.phase == 'ended' then
        if event.phase == 'ended' then
        	
			sb.gotoScene(g.dir.main..'startMenu' )
        	
		end
        
end
	bg:addEventListener('touch', drag)


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

	Runtime:removeEventListener('touch', drag)
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

