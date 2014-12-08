
--[[

	LuaQwk, a small library of useful functions to speed up coding



	map(table, function)   => iterate over table; set every value to function(value, key)
	mapT(table, function)  => same as map but for trees of data (tables with tables in them)


	process(table, functions...)  => iterate over table; call each function listed with (element, key)
	processT(table, functions...) => same as process but for trees of data (tables with tables in them)


	merge(keep, overwrite) => merge 2 tables: keep the first table, and overwrite the second if there are conflictions
		Example: merge({1, 2, 3}, {3, 2, 1, 4}) -> {1, 2, 3, 4}
	
]]


local function map(tab, func)
	for k, v in pairs(tab) do
		tab[k] = func(v, k)
	end
end

local function mapT(tab, func)
	for k, v in pairs(tab) do
		tab[k] = func(v)
		if type(v) == "table" then
			mapT(v, func)
		end
	end
end



local function process(tab, ...)
	local funcs = {...}
	for k, v in pairs(tab) do
		for _, f in pairs(funcs) do
			f(v, k)
		end
	end
end

local function processT(tab, ...)
	local funcs = {...}
	for k, v in pairs(tab) do
		if type(v) == "table" then
			for _, f in pairs(funcs) do
				f(v)
			end
			processT(v, ...)
		else
			for _, f in pairs(funcs) do
				f(v)
			end
		end
	end
end



local function merge(keep, overwrite)
	for key, val in pairs(keep) do
		overwrite[key] = val
	end
	return overwrite
end



return {
	map         = map,
	mapT        = mapT,
	merge       = merge,
	process     = process,
	processT    = processT,
}
