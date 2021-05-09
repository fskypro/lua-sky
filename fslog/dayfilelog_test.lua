local dflog = require("fsky").gDFLog
dflog.init("test", "./logs")
dflog.setNewLogCmd("./linklog.sh")

dflog.debug("123", "456")
dflog.hack("456", "789")
dflog.trace("aaaa", "bbbbb")

dflog.hackf("aaaaaa: %s", "hehe")
dflog.infof("xxxxx: %d", 200)
dflog.errorf("vvvvv: %d", 200)
dflog.tracef("yyyy: %s", "嘿嘿")

