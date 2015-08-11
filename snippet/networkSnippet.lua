--------------------------------------------------------------------------------------------------
local dbg = require('dbg')
if (dbg) then dbg.activeFile('main') end
--------------------------------------------------------------------------------------------------
if (not dbg) then print('Debugging turned OFF') end
--------------------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
--------------------------------------------------------------------------------------------------
if (dbg) then dbg.out('*------------------------------------------------------------------------------------------------*') end 

--------------------------------------------------------------------------------------------------
--init random function
math.randomseed(os.time())
math.random() --bug in first use
--local uuid = chat:UUID()

--------------------------------------------------------------------------------------------------
-- Initiate Multiplayer PubNub Object
--
-- INIT CHAT:
-- This initializes the pubnub networking layer.
--
require 'pubnub'
chat = pubnub.new({
    publish_key   = 'pub-c-7bbfbb89-9ff2-41eb-8c46-b63de0a29326', -- 'demo',
    subscribe_key = 'sub-c-f94703a2-65ca-11e2-9023-12313f022c90', -- 'demo',
    secret_key    = nil,
    ssl           = nil,
    origin        = 'pubsub.pubnub.com'
})



local id
-- 
-- CHAT CHANNEL DEFINED HERE
-- 
CHAT_CHANNEL = 'PubNub-Chat-Channel'



local group = display.newGroup()

local data = display.newText('',10, 140, 480,40)
data:setTextColor( 10, 200, 180 )
data.size = 16
group:insert( data )
local function outData(msg)
	data.text = msg
	decodeOp(data.text)
end

local status = display.newText('STATUS',10, 240, 480,40)
status:setTextColor( 10, 200, 180 )
status.size = 16
group:insert( status )
local function outStatus(msg)
	status.text = msg
end

-- 
-- STARTING WELCOME MESSAGE FOR THIS EXAMPLE
-- 
--textout('...')
--textout(' ')

-- 
-- HIDE STATUS BAR
-- 
display.setStatusBar( display.HiddenStatusBar )

--------------------------------------------------------------------------------------------------

-- 
-- CREATE CHATBOX TEXT INPUT FIELD
-- 
chatbox = native.newTextField( 0, 0, display.contentWidth - 20, 20, function(event)
    -- Only send when the user is ready.
    if not (event.phase == 'ended' or event.phase == 'submitted') then
        return
    end

    -- Don't send Empyt Message
    if chatbox.text == '' then return end

    send_a_message('input',tostring(chatbox.text))
    chatbox.text = ''
    native.setKeyboardFocus(nil)
end )

--------------------------------------------------------------------------------------------------

--
-- A FUNCTION THAT WILL OPEN NETWORK A CONNECTION TO PUBNUB
--
function connect()
    chat:subscribe({
        channel  = CHAT_CHANNEL,
        connect  = function() outStatus('Connected!') end,
        callback = function(message) outData(message.msgtext) end,
        errorback = function() outStatus('Oh no!!! Dropped 3G Conection!') end
    })



end
--------------------------------------------------------------------------------------------------

--
-- A FUNCTION THAT WILL CLOSE NETWORK A CONNECTION TO PUBNUB
--
function disconnect()
    chat:unsubscribe({channel = CHAT_CHANNEL})
    outStatus('Disconnected!')
end
--------------------------------------------------------------------------------------------------

--
-- A FUNCTION THAT WILL SEND A MESSAGE
--
function send_a_message(opcode,thisData)
	local text = id..','..opcode..','..thisData
    chat:publish({
        channel  = CHAT_CHANNEL,
        message  = { msgtext = text },
        callback = function(info)
        end
    })
end
--------------------------------------------------------------------------------------------------

--
-- OPEN NETWORK CONNECTION VIA PUBNUB
--
connect()
--------------------------------------------------------------------------------------------------
data.text = ''
data.text = math.random()
while(data.text == '') do
	data.text = math.random()
	send_a_message('randomOp',data.text)
end

id = data.text
print(id)

--------------------------------------------------------------------------------------------------
function Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = '(.-)' .. delim .. '()'
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

--------------------------------------------------------------------------------------------------
function decodeOp(opcode)
	local ops = {}
	ops = Split(opcode,',')
	
	if (ops[1] == id) then
		print('its me')
		-- do nothing
	else
		print('not me')
		-- op received from opponent
		if (ops[2] == 'submitCard') then
			print('submitting Card')
		elseif(ops[2] == 'roundComplete') then
			print('Round is complete')
		elseif(ops[2] == 'gameOver') then
			print('Game is over')
		else
			print('ERROR: Unknown opcode in decodeOp()')
		end
	end

	print (ops[1],ops[2],ops[3])
end
--------------------------------------------------------------------------------------------------
function runOp(opcode,thisData)
	send_a_message(opcode..','..thisData)
end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--move tile map
local prevX, prevY
local function drag(event)
        if event.phase == 'began' then
        	send_a_message('roundComplete','datadatadata')
        end
end
Runtime:addEventListener('touch', drag)
