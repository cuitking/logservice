--[[
	游戏流水日志模块
]]
local msgproxy = require "msgproxy"
local tabletool = require "tabletool"
local json = require "cjson"

json.encode_sparse_array(true,1,1)
local GameLog = {}

----currencyid :1 表示金币 2表示钻石
function GameLog.write_player_moneylog(rid, reason, currencyid, num, beforetotal, aftertotal)
	local data = {
		rid=rid,
		reason=reason,
		currencyid=currencyid,
		num=num,
		beforetotal=beforetotal,
		aftertotal=aftertotal,
	}
	msgproxy.sendrpc_noticemsgto_logsvrd("addlogtologsvr","moneylog",data)
end

--isreg 1 表示新注册， 0 表示已经注册账号
function GameLog.write_player_loginlog(isreg, uid, rid, regfrom, platform, channel, authtype, version, logintime)
	local data = {
		uid = uid,
		rid = rid,
		regfrom = regfrom,
		platform = platform,
		channel = channel,
		authtype = authtype,
		isreg = isreg,
		version = version,
		actiontype = "login",
		logintime = logintime,
	}
	msgproxy.sendrpc_noticemsgto_logsvrd("addlogtologsvr","loginlog",data)
end

function GameLog.write_table_records(tableid,room_type,basecoin,baseTimes,create_user_rid,playerendinfos)
	local data = {
		tableid = tableid,
		room_type = room_type,
		basecoin = basecoin,
		baseTimes = baseTimes,
		create_user_rid = create_user_rid,
		playerendinfos = json.encode(playerendinfos),
	}

	msgproxy.sendrpc_noticemsgto_logsvrd("addlogtologsvr","recordlog",data)
end


return GameLog