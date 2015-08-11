local thisFile = g.dir.library..'utility'
if (dbg) then dbg.file(thisFile) end

require 'table'
--------------------------------------------------------------------------------------------------
-- Utility class

Utility = {} 
--************************************************************************************************
-- constructor
function Utility:new(parm)
	--------------------------------------------------------------------------------------------------
	local self = {}
	self.name = 'Utility Class'
	
	--****************************************************
	self.nilToBlankStr = function (fStr)
		------------------
		--local thisFunc = 'nilToBlankStr'
		--if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
		if (fStr == nil) then
			return ''
		else
			return fStr
		end
	end

	--****************************************************
	self.split = function (str, delim, maxNb)
		------------------
		local thisFunc = 'split'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
    	-- Eliminate bad cases...
		if string.find(str, delim) == nil then
			return { str }
		end
		if maxNb == nil or maxNb < 1 then
			maxNb = 0-- No limit
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

	--****************************************************
	self.uuid = function(fLength)
		------------------
		local thisFunc = 'uuid'
		if (dbg) then dbg.func(thisFile, thisFunc) end
		------------------
        local chars = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
        local temp = {}

		for i=1,fLength do
			temp[i] = chars[math.random (36)]
		end
		local ret = table.concat(temp)
		return ret
	end
	--****************************************************
	return self
	--------------------------------------------------------------------------------------------------
end

--------------------------------------------------------------------------------------------------
local utility = Utility:new({})
return utility