LuaQwk
======

LuaQwk is a small library full of useful functions to speed up your development in general

Function listing:

```
    map(table, function)   => iterate over table; set every value to function(value, key)
	mapT(table, function)  => same as map but for trees of data (tables with tables in them)
	
	process(table, functions...)  => iterate over table; call each function listed with (element, key)
	processT(table, functions...) => same as process but for trees of data (tables with tables in them)
	
	merge(keep, overwrite) => merge 2 tables: keep the first table, and overwrite the second if there are conflictions (only overwrites string keys - elements with numerical keys are all kept)
		Example: merge({3, x = "cat"}, {1, x = "dog", 2}) -> {1, 2, 3, x = "cat"}
```
