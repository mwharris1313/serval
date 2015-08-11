local thisFile = g.dir.library..'dbLocal'
if (dbg) then dbg.file(thisFile) end
--------------------------------------------------------------------------------------------------
require 'sqlite3'
require 'table'
--local Utility = require('utility')

--------------------------------------------------------------------------------------------------
-- DBLocal class
DBLocal = {} 
--*********************************************************************************************************************************************************
-- constructor
function DBLocal:new(parm)

	
	--------------------------------------------------------------------------------------------------
	local self = {}
	----------------------------------------------------------------
	self.name = 'DBLocal'
	self.dbName = 'serval.db'
	self.path = system.pathForFile(self.dbName, system.DocumentsDirectory)
	self.db = sqlite3.open( self.path ) -- open database, if no file then create it
	----------------------------------------------------------------
	-- transposing the tConfig-table column-names to column-numbers for easier (human) retrieval. Since column data must be retrieved by column number.
	self.config = {}
	self.config.id = 1
	self.config.userName = 2
	self.config.uuid = 3
	self.config.version = 4
	----------------------------------------------------------------

	--*****************************************************************************************************************************************************
	--Handle the applicationExit event to close the db
	self.onSystemEvent = function ( event )
		------------------
		local thisFunc = 'onSystemEvent'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
	   	if( event.type == 'applicationExit' ) then
	   	    self.db:close()
	   	end
	end

	--****************************************************
	self.isFirstRun = function ()
		------------------
		local thisFunc = 'isFirstRun'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------		
		if (self.getConfigColumn('id') == nil) then
			return true
		else
			return false
		end
	end

	--****************************************************
	self.init = function ()
		------------------
		local thisFunc = 'init'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
		local tableName = 'tConfig'
		local tablesetup = [[CREATE TABLE IF NOT EXISTS ]]..tableName..[[ (id INTEGER PRIMARY KEY, userName, uuid, version, roomName, roomID, room3);]]
		self.db:exec( tablesetup )

		tableName = 'tTest'
		local tablesetup = [[CREATE TABLE IF NOT EXISTS ]]..tableName..[[ (id INTEGER PRIMARY KEY, content, content2);]]
		self.db:exec( tablesetup )

		-- TODO: level table, run for loop about 40 times for 40 levels, then the level is equal to the table row id for easy access and updating of values
	end

	--*****************************************************************************************************************************************************
	self.newConfig = function ()
		------------------
		local thisFunc = 'newConfig'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
		if ( self.isFirstRun() ) then
			local tablefill =[[INSERT INTO tConfig VALUES (1, 'anonymous',']]..util.uuid(32)..[[', '0.1', '', '', ''); ]]
			self.db:exec( tablefill )
		end
	end

	--****************************************************
	self.updateConfig = function (fColumn,fValue)
		------------------
		local thisFunc = 'updateConfig'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
		local tablefill = [[UPDATE tConfig SET ]]..fColumn..[[=']]..fValue..[[' WHERE id='1']]	
		self.db:exec( tablefill )

	end

	--****************************************************
	self.getConfigColumn = function (fColumn)
		------------------
		local thisFunc = 'getConfigColumn'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------		
		--if (dbg) then dbg.out(thisFile, thisFunc, 'TABLENAME '..util.nilToBlankStr(fTableName)) end
		for a in self.db:rows([[SELECT * FROM tConfig]]) do return a[self.config[fColumn]] end
	end

	--****************************************************
	self.showConfig = function ()
		------------------
		local thisFunc = 'showConfig'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------		
		
		for a in self.db:rows([[SELECT * FROM tConfig]]) do
			if (dbg) then dbg.out(thisFile, thisFunc, 'tConfig Table: id userName uuid version') end
			if (dbg) then dbg.out(thisFile, thisFunc, 'tConfig Table: '..a[1]..' '..a[2]..' '..a[3]..' '..a[4]..' '..a[5]..' '..a[6]) end
		end
	end



	--*****************************************************************************************************************************************************
	self.insert = function (fTableName,fID, fValue1, fValue2)
		------------------
		local thisFunc = 'insert'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------		
		local tablefill =[[INSERT INTO ]]..fTableName..[[ VALUES (]]..fID..[[, ']]..fValue1..[[',']]..fValue2..[['); ]]
		self.db:exec( tablefill )
	end

	--****************************************************
	self.update = function (fTableName,fID, fValue1, fValue2)
		------------------
		local thisFunc = 'update'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
		local tablefill = [[UPDATE ]]..fTableName..[[ SET fID='1', userName='Nissestien 67', uuid='Sandnes']]
		self.db:exec( tablefill )
	end

	--****************************************************
	self.pull = function (fTableName)
		------------------
		local thisFunc = 'pull'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------		
		if (dbg) then dbg.out(thisFile, thisFunc, 'TABLENAME '..util.nilToBlankStr(fTableName)) end		
		for row in self.db:nrows('SELECT * FROM '..fTableName) do
		    local text = row.content..' '..row.content2
		    dbg.out(thisFile, thisFunc, util.nilToBlankStr(row.id)..util.nilToBlankStr(text))
		end
	end

	--*****************************************************************************************************************************************************
	Runtime:addEventListener( 'system', self.onSystemEvent ) -- setup the system listener to catch applicationExit
	--*****************************************************************************************************************************************************
	return self

end

local obj = DBLocal:new({})
return obj
