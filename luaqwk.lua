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


-- compose(a, b, c) = function(x) return c(b(a(x))) end
function LuaQwk.compose(...)
	local fns = {...}
	return function(...)
		local result = {...}
		for _, f in pairs(fns) do
			result = LuaQwk.pack(f(unpack(result)))
		end
		return result
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



return LuaQwk
