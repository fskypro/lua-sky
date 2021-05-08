--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: 
@author: fanky
@version: 1.0
@date: 2021-05-04
--]]


return {
	init = function(fsky)
		require("fslog/logfmt").init(fsky)
		require("fslog/dayfilelog").init(fsky)
	end
}
