-- statistics.lua

local access = ngx.shared.access
local args = ngx.req.get_uri_args()
local uri = args["uri"]

local req_time_key = table.concat({uri, "-request_time"})
local total_req_key = table.concat({uri, "-request_count"})
local average_time_key = table.concat({uri, "-average_request_time"})

local count_req_sum = access:get(total_req_key) or 0
local time_req_sum = access:get(req_time_key) or 0
local time_req_ave = access:get(average_time_key) or 0

ngx.say(count_req_sum, ",", time_req_sum, ",", time_req_ave)