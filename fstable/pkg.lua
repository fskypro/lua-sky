--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: 
@author: fanky
@version: 1.0
@date: 2021-05-03
--]]


return {
	init = function(fsky)
		require("fstable/array").init(fsky)
		require("fstable/hashmap").init(fsky)
		require("fstable/util").init(fsky)
	end
}
