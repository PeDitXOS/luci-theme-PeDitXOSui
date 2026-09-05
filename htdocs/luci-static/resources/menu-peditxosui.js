"use strict";
"require baseclass";
"require ui";

/**
 * PeDitXOSui Menu Handler
 * Renders sidebar nav + tab menu for PeDitXOSui theme.
 *
 * Works with header.htm DOM:
 *   #mainmenu  → main nav container  (peeditxos-nav)
 *   #systemmenu → system tools container (peeditxos-nav)
 *   #tabmenu   → sub-tab container    (peeditxos-tabs)
 */
return baseclass.extend({
  __init__: function () {
    ui.menu.load().then(L.bind(this.render, this));
  },

  render: function (tree) {
    var node = tree,
      url = "";

    this.renderModeMenu(node);

    if (L.env.dispatchpath.length >= 3) {
      for (var i = 0; i < 3 && node; i++) {
        node = node.children[L.env.dispatchpath[i]];
        url = url + (url ? "/" : "") + L.env.dispatchpath[i];
      }
      if (node) this.renderTabMenu(node, url);
    }
  },

  /* ── Sidebar navigation ─────────────────────────────────────── */

  renderMainMenu: function (tree, url, level) {
    var l = (level || 0) + 1,
      ul = E("ul", { class: level ? "peeditxos-nav-submenu slide-menu" : "peeditxos-nav-list" }),
      children = ui.menu.getChildren(tree);

    if (children.length === 0 || l > 2) return E([]);

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.dispatchpath[l] == children[i].name,
        submenu = this.renderMainMenu(
          children[i],
          url + "/" + children[i].name,
          l
        ),
        hasChildren = submenu.children.length;

      // Build icon class from name
      var iconClass = this._iconFor(children[i].name, children[i].title);

      var li = E("li", {
        class: "peeditxos-nav-item" + (hasChildren ? " has-children" : "") + (isActive ? " active" : "")
      });

      var a = E("a", {
        href: hasChildren ? "#" : L.url(url, children[i].name),
        class: "peeditxos-nav-link" + (isActive ? " active" : ""),
        click: hasChildren
          ? this._handleExpand.bind(this)
          : null,
      }, [
        E("i", { class: "peeditxos-nav-icon " + iconClass }),
        E("span", { class: "peeditxos-nav-label" }, [_(children[i].title)]),
      ]);

      li.appendChild(a);
      if (hasChildren) li.appendChild(submenu);
      ul.appendChild(li);
    }

    // Inject into the correct container (mainmenu for level 1)
    if (l === 1) {
      var container = document.querySelector("#mainmenu");
      if (container) {
        var existing = container.querySelector(".peeditxos-nav-list");
        if (existing) existing.remove();
        container.appendChild(ul);
        container.style.display = "";
      }
    }

    return ul;
  },

  /* ── Top mode bar (Status / Network / System) ──────────────── */

  renderModeMenu: function (tree) {
    var ul = document.querySelector("#modemenu"),
      children = ui.menu.getChildren(tree);

    if (!ul) return;

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.requestpath.length
        ? children[i].name === L.env.requestpath[0]
        : i === 0;

      var iconClass = this._iconFor(children[i].name, children[i].title);

      ul.appendChild(
        E("li", {}, [
          E("a", {
            href: L.url(children[i].name),
            class: isActive ? "active" : null,
          }, [
            E("i", { class: iconClass }),
            E("span", {}, [_(children[i].title)]),
          ]),
        ])
      );

      if (isActive) this.renderMainMenu(children[i], children[i].name);

      // Divider between modes (only if more than 1 mode)
      if (i < children.length - 1) {
        ul.appendChild(E("li", { class: "divider" }, [E("span")]));
      }
    }

    if (children.length > 1) ul.parentElement.style.display = "";
  },

  /* ── Sub-tab menu (for pages with tabs) ────────────────────── */

  renderTabMenu: function (tree, url, level) {
    var container = document.querySelector("#tabmenu"),
      l = (level || 0) + 1,
      ul = E("ul", { class: "tabs peeditxos-tab-list" }),
      children = ui.menu.getChildren(tree),
      activeNode = null;

    if (!container || children.length === 0) return E([]);

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.dispatchpath[l + 2] == children[i].name,
        activeClass = isActive ? " active" : "",
        className = "peeditxos-tab-item tabmenu-item-%s %s".format(
          children[i].name,
          activeClass
        );

      ul.appendChild(
        E("li", { class: className }, [
          E("a", { href: L.url(url, children[i].name) }, [
            _(children[i].title),
          ]),
        ])
      );

      if (isActive) activeNode = children[i];
    }

    container.appendChild(ul);
    container.style.display = "";

    if (activeNode) {
      container.appendChild(
        this.renderTabMenu(activeNode, url + "/" + activeNode.name, l)
      );
    }

    return ul;
  },

  /* ── Helpers ────────────────────────────────────────────────── */

  _handleExpand: function (ev) {
    var a = ev.target.closest("a"),
      li = a.closest("li");
    if (!a || !li) return;

    // Collapse siblings
    var siblings = li.parentElement.querySelectorAll(":scope > .peeditxos-nav-item.active");
    siblings.forEach(function (s) {
      if (s !== li) {
        s.classList.remove("active");
        var link = s.querySelector(":scope > a");
        if (link) link.classList.remove("active");
      }
    });

    li.classList.toggle("active");
    a.classList.toggle("active");
    a.blur();
    ev.preventDefault();
    ev.stopPropagation();
  },

  /**
   * Map a LuCI menu node name/title to a font-awesome icon class.
   * Falls back to a generic icon.
   */
  _iconFor: function (name, title) {
    var n = (name || "").toLowerCase();
    var t = (title || "").toLowerCase();

    if (n === "status" || t.indexOf("status") !== -1) return "fa-solid fa-chart-pie";
    if (n === "overview") return "fa-solid fa-gauge-high";
    if (n === "network" || t.indexOf("network") !== -1) return "fa-solid fa-network-wired";
    if (n === "wireless" || t.indexOf("wifi") !== -1) return "fa-solid fa-wifi";
    if (n === "dhcp" || t.indexOf("dhcp") !== -1 || t.indexOf("lease") !== -1) return "fa-solid fa-list-check";
    if (n === "firewall" || t.indexOf("firewall") !== -1) return "fa-solid fa-shield-halved";
    if (n === "routing" || t.indexOf("routing") !== -1) return "fa-solid fa-route";
    if (n === "system" || t.indexOf("system") !== -1) return "fa-solid fa-gear";
    if (n === "software" || n === "opkg" || t.indexOf("software") !== -1) return "fa-solid fa-box";
    if (n === "services" || t.indexOf("service") !== -1) return "fa-solid fa-puzzle-piece";
    if (n === "vpn" || t.indexOf("vpn") !== -1) return "fa-solid fa-lock";
    if (n === "docker" || t.indexOf("docker") !== -1) return "fa-brands fa-docker";
    if (n === "ttyd" || t.indexOf("terminal") !== -1) return "fa-solid fa-terminal";
    if (n === "nas" || t.indexOf("nas") !== -1) return "fa-solid fa-hard-drive";
    if (n === "modem" || t.indexOf("modem") !== -1) return "fa-solid fa-signal";
    if (n === "log" || t.indexOf("log") !== -1) return "fa-solid fa-file-lines";
    if (n === "admin" || t.indexOf("admin") !== -1) return "fa-solid fa-user-shield";
    if (t.indexOf("passwall") !== -1) return "fa-solid fa-arrow-right-to-bracket";
    if (t.indexOf("openclash") !== -1) return "fa-solid fa-bolt";
    if (t.indexOf("istore") !== -1 || t.indexOf("store") !== -1) return "fa-solid fa-cart-shopping";

    return "fa-solid fa-cube";
  },
});
