local thisFile = 'dbg'
print('DBG FILE dbg')
--------------------------------------------------------------------------------------------------
print('Debugger is running')
		local frames = 0
		local startTime
		local endTime
		local fps
print('*------------------------------------------------------------------------------------------------*')

--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Dbg class
Dbg = {}
--************************************************************************************************
-- constructor
function Dbg:new(parm)

	--------------------------------------------------------------------------------------------------
	local self = {}
	self.isRunning = true
	self.dbgFile = true
	self.dbgFunc = true
	self.name = 'Debugger'
	self.i = 0
	
	self.out1 = display.newText('OUT1 ....', 120, 50, native.systemFontBold, 16)
	--****************************************************
	self.file = function (fFile)
		if (self.dbgFile) then
			print('FILE '..fFile)
		end
	end

	--****************************************************
	self.func = function (fFile, fFunc)
		if (self.dbgFunc) then
			print('FUNC '..fFile..' '..fFunc)
		end
	end

	--****************************************************
	self.out = function (fFile, fFunc, fStr)		
		print('---- '..fFile..' '..fFunc..' DBG '..fStr)
	end

	--****************************************************
	self.devOut = function (fMsg)
		--print('---- '..fFile..' '..fFunc..' DBG '..fStr)
		self.i = self.i + 1
		self.out1.text = self.i..' '..fMsg
		self.out1:toFront()
	end



	--****************************************************
	self.showLevel = function (level)
		local map = level.layers[1].data
		--print('FILE '..DBG TMAP '..level.width..'w x '..level.height..'h')
		local str = ''
		local i = 1
		local tile = ''
--[[
		while (map[i]) do
			if (map[i] < 10) then
				tile = ' '..map[i]
			else
				tile = ''..map[i]
			end
			str = str..' '..tile
			if (i % level.width == 0) then
				print(str)
				str = str..' '..tile
				str = ''
			end
			i = i + 1
		end
--]]



	end

	--****************************************************
	return self
	
end


--[[
function touch()
	if event.phase == 'began' then
	    frames = 0
	    startTime = system.getTimer()
	elseif event.phase == 'ended' then
	    endTime = system.getTimer()
	    info.text = 'fps ' .. (frames / (endTime - startTime)) -- Mem '.. string.sub(mem, 1, string.len(mem) - 4) .. 'mb'
	end
end
--]]



--************************************************************************************************
function showFps()
local prevTime = 0
local curTime = 0
local dt = 0       
local fps = 50
local mem = 0
 
local fpsCounter = 0
local fpsTotal = 0


local underlay = display.newRoundedRect(0, 0, 400, 80, 12)   
underlay.x = 240
underlay.y = 11
underlay:setFillColor(180, 180, 180, 80)     
local displayInfo = display.newText('FPS: ' .. fps .. ' - Memory: '.. mem .. 'mb', 120, 2, native.systemFontBold, 16)
local displayInfo2 = display.newText('FPS: ' .. fps .. ' - Memory: '.. mem .. 'mb', 120, 20, native.systemFontBold, 16)



local function updateText()
curTime = system.getTimer()
dt = curTime - prevTime
prevTime = curTime
fps = math.floor(1000 / dt)
mem = system.getInfo('textureMemoryUsed') / 1000000

--Limit fps range to avoid the 'fake' reports
if fps > 60 then
fps = 60
end

fpsCounter = fpsCounter + 1
fpsTotal = fpsTotal + fps
if (fpsCounter > 119) then
displayInfo.text = 'FPS ' .. fpsTotal/fpsCounter .. ' MEM '.. string.sub(mem, 1, string.len(mem) - 4) .. 'mb' 
displayInfo2.text = 'VCW ' .. display.viewableContentWidth .. ' VCH ' .. display.viewableContentHeight .. ' TMEM ' .. system.getInfo("maxTextureSize")
underlay:toFront()

displayInfo:toFront()
displayInfo2:toFront()
fpsTotal = 0
fpsCounter = 0
end
end

Runtime:addEventListener('enterFrame', updateText)
end

showFps()

local dbg = Dbg:new({})
return dbg