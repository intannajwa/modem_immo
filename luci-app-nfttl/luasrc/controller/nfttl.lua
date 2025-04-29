module("luci.controller.nfttl", package.seeall)

function index()
    -- Ensure "Modem" menu exists
    local page = entry({"admin", "modem"}, firstchild(), _("Modem"), 60)
    page.dependent = false

    -- Add under Modem menu
    entry({"admin", "modem", "nfttl"}, cbi("nfttl/ttl"), _("TTL Settings"), 50).leaf = true
end
