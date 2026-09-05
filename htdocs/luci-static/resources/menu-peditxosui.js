"use strict";
"require baseclass";
"require ui";

/**
 * PeDitXOSui Menu Handler
 * Simple, reliable sidebar menu renderer.
 */
return baseclass.extend({
  __init__: function () {
    ui.menu.load().then(L.bind(this.render, this));
  },

  render: function (tree) {
    // Walk the dispatch path to find the active node
    var node = tree;
    for (var i = 0; i < L.env.dispatchpath.length && node; i++) {
      node = node.children[L.env.dispatchpath[i]];
    }

    // Render sidebar: top-level items from tree root's first child (admin)
    var mode = tree.children[L.env.dispatchpath[0]] || tree.children[Object.keys(tree.children)[0]];
    if (mode) this._renderSidebar(mode);

    // Render tabs if on a tabbed page
    if (node && L.env.dispatchpath.length >= 3) {
      var tabNode = tree;
      var tabUrl = "";
      for (var j = 0; j < 3 && tabNode; j++) {
        tabNode = tabNode.children[L.env.dispatchpath[j]];
        tabUrl = tabUrl + (tabUrl ? "/" : "") + L.env.dispatchpath[j];
      }
      if (tabNode) this._renderTabs(tabNode, tabUrl);
    }
  },

  /* ── Sidebar ──────────────────────────────────────────────── */

  _renderSidebar: function (mode) {
    var container = document.querySelector("#mainmenu");
    if (!container) return;

    var children = ui.menu.getChildren(mode);
    var ul = E("ul", { class: "peeditxos-nav-list" });

    for (var i = 0; i < children.length; i++) {
      var child = children[i];
      var isActive = L.env.dispatchpath[1] === child.name;
      var icon = this._icon(child.name, child.title);

      var li = E("li", {
        class: "peeditxos-nav-item" + (isActive ? " active" : "")
      });

      var subItems = ui.menu.getChildren(child);
      var hasSub = subItems.length > 0;

      var a = E("a", {
        href: hasSub ? "#" : L.url("admin", child.name),
        class: "peeditxos-nav-link" + (isActive ? " active" : ""),
        click: hasSub ? L.bind(this._toggle, this) : null,
      }, [
        E("i", { class: "peeditxos-nav-icon " + icon }),
        E("span", { class: "peeditxos-nav-label" }, [_(child.title)]),
      ]);

      li.appendChild(a);

      // Sub-items (level 2)
      if (hasSub) {
        var subUl = E("ul", { class: "peeditxos-nav-submenu" });
        for (var k = 0; k < subItems.length; k++) {
          var sub = subItems[k];
          var subActive = L.env.dispatchpath[2] === sub.name;
          var subIcon = this._icon(sub.name, sub.title);

          var subLi = E("li", { class: "peeditxos-nav-item" + (subActive ? " active" : "") });
          var subA = E("a", {
            href: L.url("admin", child.name, sub.name),
            class: "peeditxos-nav-link" + (subActive ? " active" : ""),
          }, [
            E("i", { class: "peeditxos-nav-icon " + subIcon }),
            E("span", { class: "peeditxos-nav-label" }, [_(sub.title)]),
          ]);
          subLi.appendChild(subA);
          subUl.appendChild(subLi);
        }
        li.appendChild(subUl);
      }

      ul.appendChild(li);
    }

    // Remove old menu, inject new
    var old = container.querySelector(".peeditxos-nav-list");
    if (old) old.remove();
    container.appendChild(ul);
  },

  /* ── Tabs ─────────────────────────────────────────────────── */

  _renderTabs: function (tree, url) {
    var container = document.querySelector("#tabmenu");
    if (!container) return;

    var children = ui.menu.getChildren(tree);
    if (children.length === 0) return;

    var ul = E("ul", { class: "peeditxos-tab-list" });
    var activeChild = null;

    for (var i = 0; i < children.length; i++) {
      var child = children[i];
      var isActive = L.env.dispatchpath[3] === child.name || L.env.dispatchpath[2] === child.name;

      ul.appendChild(E("li", {
        class: "peeditxos-tab-item" + (isActive ? " active" : "")
      }, [
        E("a", { href: L.url(url, child.name) }, [_(child.title)]),
      ]));

      if (isActive) activeChild = child;
    }

    container.appendChild(ul);
    container.style.display = "";

    // Sub-tabs
    if (activeChild) {
      var subUrl = url + "/" + activeChild.name;
      var subChildren = ui.menu.getChildren(activeChild);
      if (subChildren.length > 0) {
        var subUl = E("ul", { class: "peeditxos-tab-list peeditxos-tab-sub" });
        for (var j = 0; j < subChildren.length; j++) {
          var sub = subChildren[j];
          var subActive = L.env.dispatchpath[3] === sub.name;
          subUl.appendChild(E("li", {
            class: "peeditxos-tab-item" + (subActive ? " active" : "")
          }, [
            E("a", { href: L.url(subUrl, sub.name) }, [_(sub.title)]),
          ]));
        }
        container.appendChild(subUl);
      }
    }
  },

  /* ── Helpers ──────────────────────────────────────────────── */

  _toggle: function (ev) {
    var a = ev.target.closest("a");
    var li = a ? a.closest("li") : null;
    if (!a || !li) return;

    // Collapse siblings
    var siblings = li.parentElement.querySelectorAll(":scope > .peeditxos-nav-item.active");
    for (var i = 0; i < siblings.length; i++) {
      if (siblings[i] !== li) {
        siblings[i].classList.remove("active");
      }
    }

    li.classList.toggle("active");
    a.blur();
    ev.preventDefault();
    ev.stopPropagation();
  },

  _icon: function (name, title) {
    var n = (name || "").toLowerCase();
    var t = (title || "").toLowerCase();

    if (n === "status" || t.indexOf("status") !== -1) return "fa-solid fa-chart-pie";
    if (n === "overview") return "fa-solid fa-gauge-high";
    if (n === "network") return "fa-solid fa-network-wired";
    if (n === "wireless" || t.indexOf("wifi") !== -1) return "fa-solid fa-wifi";
    if (n === "dhcp" || t.indexOf("dhcp") !== -1 || t.indexOf("lease") !== -1) return "fa-solid fa-list-check";
    if (n === "firewall") return "fa-solid fa-shield-halved";
    if (n === "routing") return "fa-solid fa-route";
    if (n === "system") return "fa-solid fa-gear";
    if (n === "software" || n === "opkg") return "fa-solid fa-box";
    if (n === "services" || t.indexOf("service") !== -1) return "fa-solid fa-puzzle-piece";
    if (n === "vpn" || t.indexOf("vpn") !== -1) return "fa-solid fa-lock";
    if (n === "docker") return "fa-brands fa-docker";
    if (n === "ttyd" || t.indexOf("terminal") !== -1) return "fa-solid fa-terminal";
    if (n === "nas") return "fa-solid fa-hard-drive";
    if (n === "modem") return "fa-solid fa-signal";
    if (n === "log") return "fa-solid fa-file-lines";
    if (n === "admin") return "fa-solid fa-user-shield";
    if (t.indexOf("passwall") !== -1) return "fa-solid fa-arrow-right-to-bracket";
    if (t.indexOf("openclash") !== -1) return "fa-solid fa-bolt";
    if (t.indexOf("istore") !== -1 || t.indexOf("store") !== -1) return "fa-solid fa-cart-shopping";

    return "fa-solid fa-cube";
  },
});
