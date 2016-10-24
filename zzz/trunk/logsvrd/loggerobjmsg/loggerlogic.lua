local skynet = require "skynet"
local base = require "base"
local msghelper = require "loggerobjhelper"
local filelog = require "filelog"
local lfs = require "lfs"
local logger = require "log4lua.logger"
local file = require("log4lua.appenders.file")

local loggerLogic = {}


function loggerLogic.init(conf,svr_id)
	local server = msghelper:get_server()
	filelog.sys_error("----loggerLogic--init----",svr_id)
	-- body
	-----判断logpath 存在与否
    local nowpath = lfs.currentdir()
    local pathtable = base.strsplit(conf.logspath,"/")
    filelog.sys_error("----------------pathtable-------",nowpath,pathtable)
    for key,value in ipairs(pathtable) do
        local status = lfs.chdir(value)
        filelog.sys_error("------test pathtable--",key,value,status)
        if status == nil then 
            lfs.mkdir(value) 
            lfs.chdir(value)
        else
        	lfs.chdir(value)
        end
    end
    lfs.chdir(nowpath)

    if server.loggerobj == nil then
        server.loggerpath = conf.logspath.."/"..string.format("%s-%s-%d.log",conf.logsname,os.date("%Y-%m-%d-%H:%M:%S"),0)
        logger.loadCategory(conf.logsname,logger.new(file.new(server.loggerpath), conf.logsname, logger.INFO))
        server.loggerobj = logger.getLogger(conf.logsname)
    end
    loggerLogic.start()
end


function loggerLogic.start()
	-- body

	local server = msghelper:get_server()
	skynet.fork(
		function()
			local i = 0
			while true do
				skynet.sleep(100)
				i = i + 1
				local writestring = string.format("write=========%d", i)
        		server.loggerobj:info(writestring,"foo","chinese")

        		local attr = lfs.attributes(server.loggerpath)
        	    filelog.sys_error("------file-attr-------",server.loggerpath,attr.size)
        		if attr.size > conf.splitfilesize then
            		server.loggerpath = conf.logspath.."/"..string.format("%s-%s-%d.log",conf.logsname,os.date("%Y-%m-%d-%H:%M:%S"),i)
            		logger.loadCategory(conf.logsname,logger.new(file.new(server.loggerpath), conf.logsname, logger.INFO))
            		server.loggerobj = logger.getLogger(conf.logsname)
        		end
			end
		end)


end











return loggerLogic