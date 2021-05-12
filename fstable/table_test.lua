local fstable = require("fsky").fstable

local list = {
	'nil',
	'300',
	'nil',
	'nil',
	'nil',
	'500',
	'nil'
}

list = fstable.reverse(list)

print(fstable.listout(list))

local dict = {
	aa = 100,
	bb = 200,
	cc = 300,
	[10] = 50,
}

print(fstable.dictout(dict))

local tb1 = fstable.update(dict, {cc = 400})
print(fstable.dictout(tb1))

local tb2 = fstable.union(dict, {cc = 400})
print(fstable.dictout(tb2))


