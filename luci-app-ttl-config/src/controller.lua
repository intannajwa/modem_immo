module("luci.controller.ttlconfig", package.seeall)

local ttlconfig = require("luci.model.cbi.ttlconfig")

function index()
    entry({"admin", "modem", "ttl-config"}, cbi("ttl-config/ttlconfig"), _("TTL Config"), 60)

    -- Fetch the current TTL value
    local current_ttl = ttlconfig.get_current_ttl()

    -- Handle form submission
    if luci.http.formvalue("submit") then
        local ttl_value = luci.http.formvalue("ttl_value")
        if ttl_value then
            ttlconfig.set_ttl_value(ttl_value)  -- Apply the new TTL value to all chains
            luci.sys.call("uci commit")  -- Commit changes if any
            luci.http.redirect(luci.dispatcher.build_url("admin/modem/ttl-config"))
        end
    end

    -- Render the TTL configuration page and pass the current TTL value
    luci.template.render("ttl-config/ttlconfig", {ttl_value = current_ttl})
end
