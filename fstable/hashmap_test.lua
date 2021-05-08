local HashMap = require("fsky").HashMap

local hm = HashMap.new({aa=1, bb=2, dd=nil, cc=3})
hm.set("dd", nil)
local hm2 = HashMap.new({ee=6})
print(hm2..{ff=90} )

print(hm)
hm.delete("dd")
print(hm)
