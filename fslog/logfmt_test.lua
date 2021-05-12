local logfmt = require("fsky").logfmt

print(logfmt.fmt(0, "[INFO] ", "asdfasdf"))
print(logfmt.tracefmt(0, "[TRACE]", "asdfasdf"))

print(logfmt.fmtf(0, "[ERROR]", "asdfasdf: %d", 1))
print(logfmt.tracefmtf(0, "[TRACE]", "asdfasdf: %d", 2))
