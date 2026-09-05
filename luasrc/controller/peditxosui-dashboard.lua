-- PeDitXOSui Dashboard Controller
-- Copyright 2025 PeDitX <t.me/peditx>

module("luci.controller.peditxosui-dashboard", package.seeall)

function index()
    -- Dashboard at its own path (do NOT override built-in routes)
    entry({"admin", "status", "peditxosui"}, call("action_dashboard"), _("PeDitXOS Dashboard"), 2)
end

function action_dashboard()
    local http = require "luci.http"
    local uci = require "luci.model.uci".cursor()

    -- Handle POST for static lease
    if http.getenv("REQUEST_METHOD") == "POST" then
        local action = http.formvalue("action")
        if action == "set_static" then
            local mac = http.formvalue("mac")
            local ip = http.formvalue("ip")
            local name = http.formvalue("name") or "device"
            if mac and ip then
                uci:section("dhcp", "host", nil, { mac = mac, ip = ip, name = name })
                uci:commit("dhcp")
                luci.http.redirect(luci.dispatcher.build_url("admin", "status", "peditxosui"))
                return
            end
        end
    end

    luci.template.render("peditxosui/dashboard")
end
