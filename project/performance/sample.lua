#!/usr/bin/lua5.1
lunajson = require 'lunajson'

-- install missing repos 
-- RUN apt install luarocks
-- RUN luarocks install lunajson
-- RUN luarocks install luasocket

-- https://github.com/lunarmodules/luasocket/ 
-- https://community.ezlo.com/t/using-lua-to-send-a-post-request-with-json-data/187146
http = require 'socket.http'

local https = require("ssl.https")
local io = require("io")
local ltn12 = require("ltn12")


local payload = '{ "direction": "offer", 	"title": "asd" }'
local resp = {}


-- c = respond code (most cases 200)
-- h = header 
local r, c, h, status = http.request{
	url = 'http://192.168.1.120:870/ads/create/',
	method = 'POST',
	source = ltn12.source.string(payload),
	headers = {
		["content-type"] = "application/json", -- change if you're not sending JSON
		["content-length"] = payload:len()
	},
	-- sink = ltn12.sink.file(io.stdout), -- for debnig only, sync to console 
	sink = ltn12.sink.table(resp)	
}

local respCode = lunajson.decode(resp[1])['code']

print("\n", 'Respond code: ' .. respCode)

-- for k,v in pairs(resp) do print(k,v) end
print(table.concat(resp))


--
wrk.path   = "/ads/create/"
wrk.method = "POST"
wrk.body   = '{"direction": "offer"}'
wrk.headers["Content-Type"] = "application/json"

requests = 0

function request()
	requests = requests + 1
	return wrk.request()
end

response = function(status, headers, body)
	local resp = lunajson.decode( body )
	-- io.write("Response with status: ".. status .."\n")
	-- io.write("Request no:", requests, "\n")
	-- io.write("[response] Body:\n")
	---- io.write(body .. "\n")
	-- print('Success state: ', resp['success'], "; Code: " .. resp['code'] .. "; Msg: " .. resp['msg'], "\n")
end
