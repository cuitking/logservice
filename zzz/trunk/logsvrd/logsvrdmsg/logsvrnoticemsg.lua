local skynet = require "skynet"
local filelog = require "filelog"
local filename = "logsvrnoticemsg.lua"
local msghelper = require "logsvrmsghelper"
local configdao = require "configdao"
local tabletool = require "tabletool"
local base = require "base"

local LogsvrNoticeMsg = {}

function LogsvrNoticeMsg.process(session, source, event, ...)
	local f = LogsvrNoticeMsg[event]
	if f == nil then
		filelog.sys_error(filename.." LogsvrNoticeMsg.process invalid event:"..event)
		return nil
	end
	f(...)
end

function LogsvrNoticeMsg.addlogtologsvr(loggerkind,message)
    filelog.sys_error("-------------test--------",loggerkind,message)
    local messagestring = ""
    if type(message) == "table" then
    	messagestring = messagestring .. tabletool.tostring(message)
    else
    	return
    end
    filelog.sys_error("----------messagestring ----",messagestring)
    local server = msghelper:get_server()
   	local logscfg = configdao.get_common_conf("logscfg")
   	for key,value in pairs(logscfg) do
   		if value.logsname == loggerkind then
   			local randomserverid = base.get_random(value.begin_id,value.begin_id+value.num)
   			if server.logger_pool[randomserverid] then
   				local result = skynet.call(server.logger_pool[randomserverid], "lua", "cmd", "addlog", messagestring)
   				break
			end
   		end
   	end
end


return LogsvrNoticeMsg