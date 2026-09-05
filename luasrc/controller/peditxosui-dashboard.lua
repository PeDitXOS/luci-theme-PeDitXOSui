module("luci.controller.peditxosui-dashboard", package.seeall)

function index()
    entry({"admin", "status", "overview"}, call("action_dashboard"), "Status", 1)
end

function action_dashboard()
    luci.template.render("themes/peditxosui/header", { title = "Status" })
    luci.template.render("peditxosui/dashboard")
    luci.template.render("themes/peditxosui/footer")
end