--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: log formater
@author: fanky
@version: 1.0
@date: 2021-04-24
--]]

local fsstr = require("fsstr/str").str

----------------------------------------------------------------------
-- private
----------------------------------------------------------------------
local prefixes = {
	debug = "[DEBUG]|",
	error = "[ERROR]|",
	info  = "[INFO] |",
	warn  = "[WARN] |",
	hack  = "[HACK] |",
	trace = "[TRACE]|",
}

local function _gettime()
	local clock = os.clock() * 1000000
	clock = tostring(math.floor(clock))
	clock = string.sub(clock, -4, -1)
	return os.date("%Y-%m-%d %H:%M:%S.") .. clock
end

local function _output(layer, prefix, msg, ...)
	local info = debug.getinfo(layer+1)
	local segs = {
		prefixes[prefix],
		_gettime(),
		" ",
		string.sub(info.source, 2, -1),
		":",
		info.currentline,
		": ",
		tostring(msg)
	}
	for i=1, select('#', ...) do
		table.insert(segs, " " .. tostring(select(i, ...)))
	end
	return table.concat(segs)
end

local function _outputf(layer, prefix, msg, ...)
	local info = debug.getinfo(layer+1)
	local segs = {
		prefixes[prefix],
		_gettime(),
		" ",
		string.sub(info.source, 2, -1),
		":",
		info.currentline,
		": ",
		string.format(msg, ...)
	}
	return table.concat(segs)
end

function _outtrace(layer)
	layer = layer + 1
	local indents = "  "
	local segs = {"\n", indents, "traceback:"}
	while(true)
	do
		layer = layer + 1
		local info = debug.getinfo(layer)
		if info == nil then break end
		indents = indents .. "  "
	
		table.insert(segs, "\n")
		table.insert(segs, indents)
		table.insert(segs, string.sub(info.source, 2, -1))
		table.insert(segs, ":" .. info.currentline)
		local fname = info.name
		if fname ~= nil then
			table.insert(segs, ": in function '" .. fname .. "'")
		end
	end
	return table.concat(segs)
end

----------------------------------------------------------------------
-- public
----------------------------------------------------------------------
local logfmt = {}

-- 所有支持的频道名称
function logfmt.channels() 
	local channels = {}
	for k, v in pairs(prefixes) do
		table.insert(channels, k)
	end
	return cahnnels
end

------------------------------------------------------------
-- 以空格分隔参数，直白返回 log 消息
------------------------------------------------------------
function logfmt.debug(layer, msg, ...)
	return _output(layer+1, "debug", msg, ...)
end

function logfmt.error(layer, msg, ...)
	return _output(layer+1, "error", msg, ...)
end

function logfmt.info(layer, msg, ...)
	return _output(layer+1, "info", msg, ...)
end

function logfmt.warn(layer, msg, ...)
	return _output(layer+1, "warn", msg, ...)
end

function logfmt.hack(layer, msg, ...)
	return _output(layer+1, "hack", msg, ...)
end

function logfmt.trace(layer, msg, ...)
	layer = layer + 1
	local msg = _output(layer+1, "trace", msg, ...)
	return msg .. _outtrace(layer)
end

------------------------------------------------------------
-- 格式化返回 log 消息
------------------------------------------------------------
function logfmt.debugf(layer, msg, ...)
	return _outputf(layer+1, "debug", msg, ...)
end

function logfmt.errorf(layer, msg, ...)
	return _outputf(layer+1, "error", msg, ...)
end

function logfmt.infof(layer, msg, ...)
	return _outputf(layer+1, "info", msg, ...)
end

function logfmt.warnf(layer, msg, ...)
	return _outputf(layer+1, "warn", msg, ...)
end

function logfmt.hackf(layer, msg, ...)
	return _outputf(layer+1, "hack", msg, ...)
end

function logfmt.tracef(layer, msg, ...)
	layer = layer + 1
	local msg = _outputf(layer+1, "trace", msg, ...)
	return msg .. _outtrace(layer)
end


----------------------------------------------------------------------
-- initialize
----------------------------------------------------------------------
return {
	init = function(fsky)
		fsky.logfmt = logfmt
	end,

	logfmt = logfmt,
}

