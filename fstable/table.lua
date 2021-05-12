--[[
@copyright: fantasysky 2016
@website: https://www.fsky.pro
@brief: utils for table
@author: fanky
@version: 1.0
@date: 2021-05-02
--]]

local fstable = {}

------------------------------------------------------------
-- 获取 table 的所有 key，以新的 table 返回
function fstable.keysof(tb)
	local keys = {}
	for k, _ in pairs(tb) do
		table.insert(keys, k)
	end
	return keys
end

-- 获取 table 的所有 value，以新的 table 返回
function fstable.valuesof(tb)
	local values = {}
	for _, v in pairs(tb) do
		table.insert(values, v)
	end
	return values
end

------------------------------------------------------------
-- 合并多个 table，并返回一个新的 table
-- 出现在参数后面的 table，其元素将会覆盖前面的
function fstable.update(tb1, ...)
	local newtb = {}
	for k, v in pairs(tb1) do
		newtb[k] = v
	end

	for _, tb in pairs({...}) do
		for k, v in pairs(tb) do
			newtb[k] = v
		end
	end
	return newtb
end

-- 合并多个 table，并返回一个新的 table
-- 如果在参数前面的 table 已经存在某个 key，则后面的 table 的同名 key 将会被丢弃
function fstable.union(tb1, ...)
	local newtb = {}
	local tbs = {...}
	for i = #tbs, 1, -1 do
		for k, v in pairs(tbs[i]) do
			newtb[k] = v
		end
	end
	for k, v in pairs(tb1) do
		newtb[k] = v
	end
	return newtb
end

------------------------------------------------------------
-- 对数组 table 元素进行翻转
function fstable.reverse(tb)
	local newtb = {}
	local count = #tb
	for i = count, 1, -1 do
		newtb[count-i+1] = tb[i]
	end
	return newtb
end

------------------------------------------------------------
-- 字符串形式列出所有数组表元素
function fstable.listout(tb)
	local items = {}
	local idx = 1
	for k, v in pairs(tb) do
		if k > idx then
			for i = idx, k - 1 do
				table.insert(items, "nil")
			end
		end
		if type(v) == 'string' then
			v = '"' .. v .. '"'
		else
			v = tostring(v)
		end
		table.insert(items, v)
		idx = k + 1
	end
	return 'Table[' .. table.concat(items, ',') .. ']'
end

-- 字符串形式列出所有映射表元素
function fstable.dictout(tb)
	local items = {}
	for k, v in pairs(tb) do
		if type(v) == 'string' then
			v = '"' .. v .. '"'
		else
			v = tostring(v)
		end
		table.insert(items, tostring(k) .. '=' .. v)
	end
	return 'Table{' .. table.concat(items, ',') .. '}'
end

----------------------------------------------------------------------
-- initialize
----------------------------------------------------------------------
return {
	init = function(fsky, tofsky)
		fsky.fstable = fstable
	end,

	table = fstable,
}
