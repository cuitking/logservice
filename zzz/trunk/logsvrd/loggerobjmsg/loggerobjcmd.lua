--
-- Created by IntelliJ IDEA.
-- User: juzhong
-- Date: 2016/10/11
-- Time: 17:54
-- To change this template use File | Settings | File Templates.
--
local skynet = require "skynet"
local filelog = require "filelog"
local msghelper = require "loggerobjhelper"
local base = require "base"
local logger = require "log4lua.logger"
local file = require("log4lua.appenders.file")
local filename = "loggerobjcmd.lua"
local LoggerobjCmd = {}

function LoggerobjCmd.process(session, source, event, ...)
    local f = LoggerobjCmd[event]
    if f == nil then
        filelog.sys_error(filename.." AgentCMD.process invalid event:"..event)
        return nil
    end
    f(...)
end

function LoggerobjCmd.start(conf,svr_id)
	filelog.sys_error("-----------LoggerobjCmd.start-------------",conf,svr_id)
    local server = msghelper:get_server()
    filelog.sys_error("++++++++++++++++++++",server)
    --logger.loadConfig("log4lua/loggerconfig.lua")

    --local writelogger = logger.getLogger("foo")
    --writelogger:info("1111","foo","3333")

    if server.loggerobj == nil then
         logger.loadCategory("foo",logger.new(file.new("foo-%s.log", "%Y-%m-%d"), "foo", logger.INFO))
         server.loggerobj = logger.getLogger("foo")
    end
    for i = 1,10000 do
         local writestring = string.format("write=========%d", i)
         server.loggerobj:info(writestring,"foo","chinese")
    end
	base.skynet_retpack(true)
end


return LoggerobjCmd


