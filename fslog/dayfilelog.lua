--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: log printer for a file every day
@author: fanky
@version: 1.0
@date: 2021-04-30
--]]


local class = require("fsoo/oo").class
local fsos = require("fsos/os").os
local logfmt = require("fslog/logfmt").logfmt
local fspath = require("fsos/path").path


local DayFileLog = class("DayFileLog")
do
	------------------------------------------------------------------
	-- private
	------------------------------------------------------------------
	-- 创建 log 文件
	function DayFileLog._newLogFile(this)
		if this._file then
			this._file:close()
		end

		local prefix = this._prefix
		if prefix ~= "" then
			prefix = prefix .. "_"
		end
		local today = os.date('%Y-%m-%d')
		local fileName = prefix .. today .. this._logext
		local path = fspath.join(this._logdir, fileName)
		local err
		if fspath.filePathExists(path) then
			this._file, err = io.open(path, 'a')
		else
			this._file, err = io.open(path, 'w')
		end
		if this._file ~= nil then
			local sp = string.rep('-', 50)
			local now = os.date('%H:%M:%S')
			this._file:write(string.format("%s %s %s%s", sp, now, sp, fsos.newline()))
			this._lastday = os.date("%Y%m%d")
		else
			print("create logfile fail:\n\t", err)
		end
	end

	function DayFileLog._output(this, msg)
		if not this._inited then
			print(msg)
			return
		end

		if os.date("%Y%m%d") ~= this._lastday then
			this._newLogFile()
		end
		if this._file then
			this._file:write(msg .. fsos.newline())
			this._file:flush()
		else
			print(msg)
		end
	end

	------------------------------------------------------------------
	-- private
	------------------------------------------------------------------
	function DayFileLog.f_ctor(this)
		this._inited = false
	end

	-- 设置 log 属性
	-- prefix 为 log 文件前缀，省略为没有前缀
	-- logdir 为 log 输出文件夹，省略为 ./logs
	-- ext 为 log 文件扩展名，可省略，省略后，默认为 .log
	function DayFileLog.init(this, prefix, logdir, ext)
		if type(prefix) ~= 'string' then prefix = "" end
		if type(logdir) ~= 'string' then logdir = "./logs" end
		if type(ext) ~= 'string' then ext = ".log" end
		if string.sub(ext, 1, 1) ~= '.' then ext = '.' .. ext end
		this._prefix = prefix
		this._logdir = logdir
		this._logext = ext
		this._file = nil

		this._newLogFile()
		this._inited = true
	end

	------------------------------------------------------------
	function DayFileLog.debug(this, msg, ...)
		msg = logfmt.debug(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.info(this, msg, ...)
		msg = logfmt.info(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.warn(this, msg, ...)
		msg = logfmt.warn(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.error(this, msg, ...)
		msg = logfmt.error(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.hack(this, msg, ...)
		msg = logfmt.hack(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.trace(this, msg, ...)
		msg = logfmt.trace(1, msg, ...)
		this._output(msg)
	end

	------------------------------------------------------------
	function DayFileLog.debugf(this, msg, ...)
		msg = logfmt.debugf(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.infof(this, msg, ...)
		msg = logfmt.infof(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.warnf(this, msg, ...)
		msg = logfmt.warnf(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.errorf(this, msg, ...)
		msg = logfmt.errorf(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.hackf(this, msg, ...)
		msg = logfmt.hackf(1, msg, ...)
		this._output(msg)
	end

	function DayFileLog.tracef(this, msg, ...)
		msg = logfmt.tracef(1, msg, ...)
		this._output(msg)
	end

	------------------------------------------------------------
	function DayFileLog.close(this)
		if this._file then
			this._file:close()
		end
	end
end

--------------------------------------------------------------------------------
-- initialize
--------------------------------------------------------------------------------
return {
	init = function(fsky)
		fsky.DFLog = DayFileLog
		fsky.gDFLog = DayFileLog.new()
	end,

	DFLog = DayFileLog,
}
