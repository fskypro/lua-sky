--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: lua 
@author: fanky
@version: 1.0
@date: 2021-04-27
--]]

local fsky = {}

-- 子包利用 tofsky 函数，可以将参数中的成员全部拷贝到 fsky
local function tofsky(tb)
	local function exists(key)
		for k, v in pairs(fsky) do
			assert(name ~= k, string.format("prop key '%s' for fsky has been conflict.", k))
		end
	end

	for k, v in pairs(tb) do
		fsky[k] = v
	end
end

require("fsdefine").init(fsky, tofsky)
require("fsutil").init(fsky, tofsky)
require("fsoo.pkg").init(fsky, tofsky)
require("fserror.pkg").init(fsky, tofsky)
require("fsstr.pkg").init(fsky, tofsky)
require("fstable.pkg").init(fsky, tofsky)
require("fsos.pkg").init(fsky, tofsky)
require("fslog.pkg").init(fsky, tofsky)

------------------------------------------------------------
-- global
------------------------------------------------------------
_ENV.fs_len = fsky.fstable.length			-- 获取表长度
_ENV.fs_keys = fsky.fstable.keysof			-- 获取表的所有键 table（fstable/table.lua::keysof）
_ENV.fs_values = fsky.fstable.valuesof		-- 获取表的所有值 table（fstable/table.lua::valuesof）
_ENV.fs_lout = fsky.fstable.listout			-- 输出一层数组 table（fstable/table.lua::listout）
_ENV.fs_dout = fsky.fstable.dictout			-- 输出一层键值 table（fstable/table.lua::dictout）
_ENV.fs_dfmt = fsky.fstable.dictfmt			-- 格式化输出键值 table（fstable/table.lua::dictfmt）

return fsky

