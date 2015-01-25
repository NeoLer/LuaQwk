--[[
	LuaQwk is a small collection of tools to speed up general coding in Lua
	 See github.com/Snoxicle/LuaQwk for latest release
	  Using LuaQwk:
	 	local LuaQwk = require("luaqwk") -- all of LuaQwk is returned in a table
]]

LuaQwk = {}



-- Lets you index strings like you would tables if called
function LuaQwk.enableArrayStyleStringIndexes()
	getmetatable('').__index = function(self, i)
		if type(i) == "string" then
			return string[i]
		else
			return string.sub(self, i, i)
		end
	end
end


-- Overwrite/merge keep with overwrite
function LuaQwk.merge(keep, overwrite)
	for key, val in pairs(keep) do
		if type(key) == "string" then
			overwrite[key] = val
		else
			overwrite[#overwrite + 1] = val
		end
	end
	return overwrite
end


-- Traverse over t, call each function with (value, key)
function LuaQwk.process(t, ...)
	local funcs = {...}
	for k, v in pairs(t) do
		for _, f in pairs(funcs) do
			f(v, k)
		end
	end
end

-- Traverse over t, setting each element to f(element)
function LuaQwk.map(t, f)
	for k, v in pairs(t) do
		t[k] = f(v)
	end
	return t
end

-- Create a new table u. For each element of t, set u[element] = f(element)
function LuaQwk.mapCpy(t, f)
	local u = {}
	for k, v in pairs(t) do
		u[k] = f(v)
	end
	return u
end


-- The opposite of unpack()
function LuaQwk.pack(...)
	return {...}
end


--[[
local LuaQwk = require("luaqwk")
local speedtestN = function(n) return math.floor(math.sqrt(n)) end 
local speedtestC = LuaQwk.compose(math.sqrt, math.floor)
print(
	"Manual implementation: " .. LuaQwk.timeF(function()
		for i = 1, 1000000000 do
			speedtestN(i)
		end
	end),
	"\nLuaQwk.compose: " .. LuaQwk.timeF(function()
		for i = 1, 1000000 do
			speedtestC(i)
		end
	end)
)
(Manual does it 1000 more times)
>>Manual implementation: 1.884	
>>LuaQwk.compose: 2.028
]]


-- compose(a, b, c) = function(...) return c(b(a(...))) end
-- warning: VERY slow! the functions themselves are not slow, but packing/unpacking is.
-- good use case: something like compose(expensive, expensive, expensive) used a few times (totally fine)
-- bad use case: something like compose(cheap, cheap, cheap) 1000s of times (DON'T!)
function LuaQwk.compose(...)
	local unpack = unpack
	local unpacker = function(t)     -- really ugly, but faster than unpack assuming
		if #t == 1 then return t[1]   -- you probably aren't going to be using more than 5
		elseif #t == 2 then return t[1], t[2] -- return values
		elseif #t == 3 then return t[1], t[2], t[3]
		elseif #t == 4 then return t[1], t[2], t[3], t[4]
		elseif #t == 5 then return t[1], t[2], t[3], t[4], t[5]
		end
		return unpack(t)
	end
	local fns = {...}
	return function(...)
		local result = {...}
		for i = 1, #fns do
			result = {fns[i](unpacker(result))}
		end
		return unpack(result)
	end
end

-- composeSingle: like compose, but no variable arguments on the composed function
-- still slow, but far faster than compose because packing/unpacking is not needed
function LuaQwk.composeSingle(...)
	local fns = {...}
	return function(x)
		local result = x
		for i = 1, #fns do
			result = fns[i](result)
		end
		return result
	end
end

-- 2-argument version of composeSingle
function LuaQwk.composeDouble(...)
	local fns = {...}
	return function(x, y)
		local result1, result2 = x, y
		for i = 1, #fns do
			result1, result2 = fns[i](result1, result2)
		end
		return result1, result2
	end
end


-- Returns true if any argument is nil, else false
function LuaQwk.anyNil(...)
	for _, v in pairs({...}) do
		if v == nil then
			return true
		end
	end
	return false
end

-- Calls f unless maybeNil is nil
function LuaQwk.callUnlessNil(maybeNil, f)
	if maybeNil ~= nil then
		return f(maybeNil)
	else
		return nil
	end
end


-- Time func and return time as number
function LuaQwk.timeF(f, ...)
	local start = os.clock()
	f(...)
	return os.clock() - start
end



return LuaQwk
