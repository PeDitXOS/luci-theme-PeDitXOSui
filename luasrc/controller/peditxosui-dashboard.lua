module("luci.controller.peditxosui-dashboard", package.seeall)

function index()
    entry({"admin", "status", "peditxosui"}, call("action_dashboard"), "PeDitXOS Dashboard", 2)
end

function action_dashboard()
    luci.template.render("themes/peditxosui/header", { title = "Status" })
    luci.template.render("peditxosui/dashboard")
    luci.template.render("themes/peditxosui/footer")
end
