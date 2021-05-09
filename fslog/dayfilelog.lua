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


--------------------------------------------------------------------------------
-- NewLogCmd
--------------------------------------------------------------------------------
local NewLogCmd = class("NewLogCmd")
do
	function NewLogCmd.f_ctor(this, cmd)
		if type(cmd) ~= 'string' then
			this._cmd = ""
		else
			this._cmd = cmd
		end
	end

	function NewLogCmd.exec(this, logger, logPath)
		if this._cmd == "" then
			return
		end
		local ret, err = io.popen(string.format("%s '%s'", this._cmd, logPath))
		if err ~= nil then
			logger.error("execute new log file command fail: ", err)
			return
		end
		logger.infof("excute new log file command '%s'. output:%s%s",
			this._cmd, 
			fsos.newline(),
			ret:read("*all"))
	end
end

--------------------------------------------------------------------------------
-- DayfileLog
--------------------------------------------------------------------------------
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
			this._logPath = path
			this._newLogCmd.exec(this, path)
		else
			print("create logfile fail:\n\t", err)
			this._logPath = ""
		end
	end

	function DayFileLog._output(this, msg)
		if not this._inited then
			print("warn: dayfilelog hasn't intialized.")
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
		this._logPath = ""					-- log 文件路径
		this._file = nil					-- log 文件流
		this._newLogCmd = NewLogCmd.new()	-- 新建 log 文件时，触发的命令
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
		this._prefix = prefix				-- log 文件前缀
		this._logdir = logdir				-- log 文件所在目录
		this._logext = ext					-- log 文件扩展名

		this._newLogFile()
		this._inited = true
	end

	-- 设置一个可执行命令，每当新建一个 log 文件时，该命令将会被执行
	function DayFileLog.setNewLogCmd(this, cmd)
		this._newLogCmd = NewLogCmd.new(cmd)
		if this._logPath ~= "" then
			this._newLogCmd.exec(this, this._logPath)
		end
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
