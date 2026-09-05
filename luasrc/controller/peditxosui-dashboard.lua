module("luci.controller.peditxosui-dashboard", package.seeall)

function index()
    -- Override default status overview with our dashboard
    entry({"admin", "status", "overview"}, call("action_dashboard"), "Status", 1)
end

function action_dashboard()
    -- Use luci.dispatcher to render full page with proper JS loading order
    luci.dispatcher.render("peditxosui/dashboard")
end