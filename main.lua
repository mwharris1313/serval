--------------------------------------------------------------------------------------------------
local thisFile = 'main'
dbg = require('dbg')
--dbg = false
print('****************************************************************************************************')
if (dbg) then dbg.file(thisFile) else print('### Debugging turned OFF ###') end
print('****************************************************************************************************')
display.setStatusBar( display.HiddenStatusBar )
--------------------------------------------------------------------------------------------------

g = require('global')
	g.ver='2013Mar06am0800'

---------------------------------------
g.createImgGroupAndSheet()
g.screen = Screen.new({heightInTiles=8})
g.level = Level.new({fileName='level1'})

g.map = Map.new({})
g.cam = Cam.new({})
g.mob = Mob.new({}) 
g.joystick = Joystick.new({})

g.map:delete()
g.deleteImgGroupAndSheet()
g.collectGarbage()
--g.createImgGroupAndSheet()

g:changeImgGroupAndSheet('128')
g.map:create()
--g.mobgroup:toFront()

---[[
--------------------------------------------------------------------------------------------------
util = require('lib.utility')
--------------------------------------------------------------------------------------------------
--display.setStatusBar( display.HiddenStatusBar )
--------------------------------------------------------------------------------------------------
if (dbg) then
end
--------------------------------------------------------------------------------------------------
db = require('lib.dbLocal')
db.init()
db.newConfig()
db.showConfig()
----------------------------------------------
sb = require 'storyboard'
--pn = require('pnNetwork')
----------------------------------------------
--sb.purgeAll()
--sb.gotoScene(g.dir.main..'startScreen' )
sb.gotoScene('main.levelLoader' )
--]]

















--[[
local options =
{
    -- array of tables representing each frame (required)
    frames =
    {
        -- FRAME 1:
        {
            -- all params below are required for each frame
            x = 2,
            y = 70,
            width = 50,
            height = 50
        },

        -- FRAME 2:
        {
            x = 2,
            y = 242,
            width = 50,
            height = 52
        },
    },

    -- optional params; used for dynamic resolution support
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
}

local imageSheet = graphics.newImageSheet( "imageframes.png", options )

--]]

--[[
Removing Image Sheets

To remove an image sheet, you simply remove 
any objects that are using the image sheet 
(which includes image objects, sprites, and image groups), 
and then set the reference to the image sheet to nil.

Here's a quick example:
-- obj1 and obj2 are using the image sheet
obj1:removeSelf()
obj1 = nil

obj2:removeSelf()
obj2 = nil

-- remove reference to the image sheet
imageSheet = nil
--]]