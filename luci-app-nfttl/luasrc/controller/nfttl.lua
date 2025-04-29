module("luci.controller.nfttl", package.seeall)

function index()
    entry({"admin", "network", "nfttl"}, cbi("ttl"), _("TTL Configuration"), 90)
end
