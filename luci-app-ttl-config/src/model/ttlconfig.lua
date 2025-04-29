local fs = require("nixio.fs")
local uci = require("uci").cursor()

module("luci.model.cbi.ttlconfig", package.seeall)

-- Function to retrieve the current TTL value from the nftables configuration
function get_current_ttl()
    local nft_config = "/etc/nftables.d/10-custom-filter-chains.nft"
    local command = "grep -oP 'ttl set \K[0-9]+' " .. nft_config
    local ttl_value = io.popen(command):read("*a")
    return ttl_value:match("%d+")
end

-- Function to set TTL value
function set_ttl_value(ttl_value)
    local nft_config = "/etc/nftables.d/10-custom-filter-chains.nft"
    local chains = {
        "mangle_prerouting_ttl64",
        "mangle_postrouting_ttl64",
        "mangle_prerouting_hoplimit64",
        "mangle_postrouting_hoplimit64"
    }

    -- Loop through all the chains and update the TTL value
    for _, chain in ipairs(chains) do
        local command = "sed -i 's/^\(.*chain " .. chain .. ".*ttl set \)[0-9]\+/\1" .. ttl_value .. "/' " .. nft_config
        os.execute(command)  -- Update the TTL value for the chain

        -- Apply the new nftables configuration
        os.execute("nft -f " .. nft_config)
    end
end
