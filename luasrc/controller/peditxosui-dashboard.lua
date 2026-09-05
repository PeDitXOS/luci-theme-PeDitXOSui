-- PeDitXOSui Dashboard Controller
-- Copyright 2025 PeDitX <t.me/peditx>

module("luci.controller.peditxosui-dashboard", package.seeall)

function index()
    entry({"admin", "status", "peditxosui"}, call("action_dashboard"), _("PeDitXOS Dashboard"), 2)
end

function action_dashboard()
    -- Render with theme wrapper (header + footer + sidebar)
    luci.template.render("themes/peditxosui/header", { title = _("Status") })
    luci.template.render("peditxosui/dashboard")
    luci.template.render("themes/peditxosui/footer")
end
