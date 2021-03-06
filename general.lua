-- general.lua

local access = ngx.shared.access
local uri = ngx.var.uri
local host = ngx.var.host
local ip = ngx.var.remote_addr
local request_time = ngx.var.request_time
local isFilter = false
local find = string.find
local filter = {"-----"}

for k, v in ipairs(filter) do
  if host == v then
    isFilter = true
  end
end

if isFilter == true then
  -- 存储的过期时间，若为0，则永远不过期
  local expire_time = 0

  -- 请求时间
  local req_time_key = table.concat({host, ":", uri, ":request_time"})
  -- 请求总数
  local total_req_key = table.concat({host, ":", uri, ":request_count"})
  -- 平均响应时间
  local average_time_key = table.concat({host, ":", uri, ":average_request_time"})
  -- 客户端ip
  local page_view_key = table.concat({host, ":", ip, ":page_view"})

  -- 计算特定uri的请求次数
  local count_req_sum = access:get(total_req_key) or 0
  count_req_sum = count_req_sum + 1
  access:set(total_req_key, count_req_sum, expire_time)

  -- 计算特定uri的响应时间
  local time_req_sum = access:get(req_time_key) or 0
  time_req_sum = time_req_sum + request_time
  access:set(req_time_key, time_req_sum, expire_time)

  -- 计算特定uri的平均响应时间
  local time_req_ave = time_req_sum / count_req_sum
  access:set(average_time_key, time_req_ave, expire_time)

  -- 计算每个ip的pv
  local page_view_sum = access:get(page_view_key) or 0
  page_view_sum = page_view_sum + 1
  access:set(page_view_key, page_view_sum, expire_time)
end