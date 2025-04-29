local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()

local config_file = "/etc/nftables.d/ttl.conf"

-- Helper to read current TTL
local function read_ttl()
    if not fs.access(config_file) then return "64" end
    local data = fs.readfile(config_file) or ""
    local ttl = data:match("set%s+(%d+)")
    return ttl or "64"
end

-- Helper to update TTL in file
local function write_ttl(ttl)
    local template = [[
chain mangle_prerouting_ttl64 {
  type filter hook prerouting priority 300; policy accept;
  counter ip ttl set %s
}

chain mangle_postrouting_ttl64 {
  type filter hook postrouting priority 300; policy accept;
  counter ip ttl set %s
}

chain mangle_prerouting_hoplimit64 {
  type filter hook prerouting priority 300; policy accept;
  counter ip6 hoplimit set %s
}

chain mangle_postrouting_hoplimit64 {
  type filter hook postrouting priority 300; policy accept;
  counter ip6 hoplimit set %s
}
]]
    local content = string.format(template, ttl, ttl, ttl, ttl)
    fs.writefile(config_file, content)
end

-- CBI Map
m = Map("nfttl", translate("TTL Settings"), translate("Adjust TTL and Hop Limit for nftables."))

s = m:section(TypedSection, "ttl", "")
s.anonymous = true

ttl = s:option(Value, "ttl", translate("TTL / Hop Limit Value"))
ttl.datatype = "uinteger"
ttl.default = read_ttl()

function m.on_commit(map)
    write_ttl(ttl:formvalue("cbi.ttl.1.ttl"))
    luci.sys.call("nft -f /etc/nftables.d/ttl.conf")
end

return m
