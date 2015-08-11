local thisFile = g.dir.library..'pnNetwork'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
math.randomseed(os.time())	-- init random function
math.random()				-- bug in first use
--local uuid = pnObj:UUID()
--------------------------------------------------------------------------------------------------

require 'pubnub'

-- send message in format below via the PubNub Dev Console to troubleshoot app
-- {'msg':'id,opcode,data'}
--------------------------------------------------------------------------------------------------
-- Pubnub class
Pubnub = {}
--************************************************************************************************
-- constructor
function Pubnub:new(parm)

	--------------------------------------------------------------------------------------------------
	local self = {}

	----------------------------------------------------------------
	self.name = 'PubnubNetwork'
	self.mainChannel = 'serval'
	--self.myChannel = self.id
	self.curChannel = self.mainChannel
	self.isRoomCreator = false
	----------------------------------------------------------------
	-- Initiate Multiplayer PubNub Object
	-- This initializes the pubnub networking layer.

	self.pnObj = pubnub.new({
		subscribe_key	= 'sub-c-d80638dc-6ac7-11e2-ae8f-12313f022c90',
		publish_key		= 'pub-c-ee663362-0c59-4e8e-9071-29d178553ae5',
		secret_key		= nil,
		ssl				= nil,
		origin			= 'pubsub.pubnub.com',
	})

	--****************************************************
	-- open network connection to pubnub
	self.connect = function ()
		local thisFunc = 'connect'
		if (dbg) then dbg.func(thisFile, thisFunc) end

		if (dbg) then dbg.func(thisFile, thisFunc, 'Connecting... '..self.pnObj.uuid) end
		self.pnObj:subscribe({
			channel  = self.curChannel,
			connect  = function() dbg.out(thisFile, thisFunc, 'Connected: '..self.curChannel..' '..self.pnObj.uuid) end,
			callback = function(message) self.receive(message.msg) end,
			errorback = function() dbg.out(thisFile, thisFunc, 'Oh no!!! Dropped 3G Conection!') end
		})
	end

	--****************************************************
	-- close connection to pubnub
	self.disconnect = function ()
		local thisFunc = 'disconnect'
		if (dbg) then dbg.func(thisFile, thisFunc) end

		self.pnObj:unsubscribe({channel = self.curChannel})
		if (dbg) then dbg.out(thisFile, thisFunc, 'disconnected') end
	end

	--****************************************************
	-- send message
	self.send = function (fCode, fData)
		local thisFunc = 'send'
		if (dbg) then dbg.func(thisFile, thisFunc) end

		local text = self.pnObj.uuid..','..fCode..','..fData
		self.pnObj:publish({
			channel  = self.curChannel,
			--message  = { msgtext = text },
			message  = { msg = text },
			callback = function(info) end
		})
		if (dbg) then dbg.out(thisFile, thisFunc, self.curChannel..' '..fCode..' '..fData) end
	end

	--****************************************************
	-- filter and execute incoming ops if from opponent
	self.receive = function (fCode)
		local thisFunc = 'receive'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		local op = {}
		op = util.split(fCode,',')

		if (op[1] == pn.pnObj.uuid) then -- opcode from me

			if (dbg) then dbg.out(thisFile, thisFunc, 'MyID '..op[1]..' '..op[2]..' '..op[3]) end

			if(op[2] == 'saveRoom') then
				db.updateConfig('roomName',op[1])
				db.updateConfig('roomID',op[3])
				db.showConfig()
				sb.gotoScene('startMenu')
			else
				if (dbg) then dbg.out(thisFile, thisFunc, 'ERROR: Unknown opcode in decodeOp()') end
			end
				
		else -- opcode not from me

			if (dbg) then dbg.out(thisFile, thisFunc, 'NotMyID '..op[1]..' '..op[2]..' '..op[3]) end
			
			if(op[2] == 'joinRoom' and self.isRoomCreator) then	
				if (dbg) then dbg.out(thisFile, thisFunc, 'Executing GuestOp: '..op[1]..' '..op[2]..' '..op[3]) end
				self.isRoomCreator = false
				self.send( 'saveRoom', self.createChannelID() )
			elseif(op[2] == 'saveRoom') then
				db.updateConfig('roomName',op[1])
				db.updateConfig('roomID',op[3])
				db.showConfig()
				sb.gotoScene('startMenu')
			else
				if (dbg) then dbg.out(thisFile, thisFunc, 'ERROR: Unknown opcode in decodeOp()') end
			end

		end
	end

	--****************************************************
	self.createChannelID = function()
		------------------
		local thisFunc = 'createChannelID'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
        local chars = {'-','_','0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
        local temp = {}
		
		for i=1,128 do
			temp[i] = chars[math.random (64)]
		end
		local ret = table.concat(temp)
		return ret
	end
	--****************************************************
	self.createRoomID = function()
		------------------
		local thisFunc = 'createRoomID'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
        local chars = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','m','n','o','p','q','r','s','t','u','v','w','x','y','z'} -- l removed
        local temp = {}
		
		for i=1,6 do
			temp[i] = chars[math.random (35)]
		end
		local ret = table.concat(temp)
		return ret
	end


	--****************************************************
	return self
end

local obj = Pubnub:new()
obj.uuid = obj.pnObj.UUID()
obj.pnObj.uuid = db.getConfigColumn('userName')..'_'..db.getConfigColumn('uuid')

return obj
