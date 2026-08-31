"use strict";
"require baseclass";
"require ui";

/**
 * PeDitXOSui Menu Handler
 * Modern menu system for PeDitXOS theme
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

    // Initialize sidebar toggle
    var showSide = document.querySelector(".showSide");
    if (showSide) {
      showSide.addEventListener("click", L.bind(this.handleSidebarToggle, this));
    }

    // Initialize dark mask for mobile
    var darkMask = document.querySelector(".darkMask");
    if (darkMask) {
      darkMask.addEventListener("click", L.bind(this.handleSidebarToggle, this));
    }

    // Hide loading indicator
    var loading = document.querySelector(".main > .loading");
    if (loading) {
      loading.style.opacity = "0";
      loading.style.visibility = "hidden";
    }

    // Handle initial sidebar state
    if (window.innerWidth <= 1152) {
      var mainLeft = document.querySelector(".main-left");
      if (mainLeft) mainLeft.style.width = "0";
    }

    window.addEventListener("resize", L.bind(this.handleSidebarToggle, this), true);
  },

  handleMenuExpand: function (ev) {
    var a = ev.target,
      ul1 = a.parentNode,
      ul2 = a.nextElementSibling;

    document.querySelectorAll("li.slide.active").forEach(function (li) {
      if (li !== a.parentNode || li == ul1) {
        li.classList.remove("active");
        li.childNodes[0].classList.remove("active");
      }
      if (li == ul1) return;
    });

    if (!ul2) return;

    if (
      ul2.parentNode.offsetLeft + ul2.offsetWidth <=
      ul1.offsetLeft + ul1.offsetWidth
    ) {
      ul2.classList.add("align-left");
    }

    ul1.classList.add("active");
    a.classList.add("active");
    a.blur();
    ev.preventDefault();
    ev.stopPropagation();
  },

  renderMainMenu: function (tree, url, level) {
    var l = (level || 0) + 1,
      ul = E("ul", { class: level ? "slide-menu" : "nav" }),
      children = ui.menu.getChildren(tree);

    if (children.length == 0 || l > 2) return E([]);

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.dispatchpath[l] == children[i].name,
        submenu = this.renderMainMenu(
          children[i],
          url + "/" + children[i].name,
          l
        ),
        hasChildren = submenu.children.length;

      ul.appendChild(
        E(
          "li",
          {
            class: hasChildren
              ? "slide" + (isActive ? " active" : "")
              : isActive
              ? " active"
              : "",
          },
          [
            E(
              "a",
              {
                href: hasChildren ? "#" : L.url(url, children[i].name),
                class: hasChildren
                  ? "menu" + (isActive ? " active" : "")
                  : null,
                click: hasChildren
                  ? ui.createHandlerFn(this, "handleMenuExpand")
                  : null,
                "data-title": hasChildren
                  ? children[i].title
                  : _(children[i].title),
              },
              [_(children[i].title)]
            ),
            submenu,
          ]
        )
      );
    }

    if (l == 1) {
      var container = document.querySelector("#mainmenu");
      if (container) {
        container.appendChild(ul);
        container.style.display = "";
      }
    }

    return ul;
  },

  renderModeMenu: function (tree) {
    var ul = document.querySelector("#modemenu"),
      children = ui.menu.getChildren(tree);

    if (!ul) return;

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.requestpath.length
        ? children[i].name == L.env.requestpath[0]
        : i == 0;

      ul.appendChild(
        E("li", {}, [
          E(
            "a",
            {
              href: L.url(children[i].name),
              class: isActive ? "active" : null,
            },
            [_(children[i].title)]
          ),
        ])
      );

      if (isActive) this.renderMainMenu(children[i], children[i].name);
      if (i > 0 && i < children.length)
        ul.appendChild(E("li", { class: "divider" }, [E("span")]));
    }

    if (children.length > 1) ul.parentElement.style.display = "";
  },

  renderTabMenu: function (tree, url, level) {
    var container = document.querySelector("#tabmenu"),
      l = (level || 0) + 1,
      ul = E("ul", { class: "tabs" }),
      children = ui.menu.getChildren(tree),
      activeNode = null;

    if (!container) return E([]);
    if (children.length == 0) return E([]);

    for (var i = 0; i < children.length; i++) {
      var isActive = L.env.dispatchpath[l + 2] == children[i].name,
        activeClass = isActive ? " active" : "",
        className = "tabmenu-item-%s %s".format(children[i].name, activeClass);

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

    if (activeNode)
      container.appendChild(
        this.renderTabMenu(activeNode, url + "/" + activeNode.name, l)
      );

    return ul;
  },

  handleSidebarToggle: function (ev) {
    var width = window.innerWidth,
      darkMask = document.querySelector(".darkMask"),
      mainRight = document.querySelector(".main-right"),
      mainLeft = document.querySelector(".main-left"),
      open = mainLeft ? mainLeft.style.width == "" : true;

    if (width > 1152 || ev.type == "resize") open = true;

    if (darkMask) {
      darkMask.style.visibility = open ? "" : "visible";
      darkMask.style.opacity = open ? "" : 1;
    }

    if (mainLeft) {
      if (width <= 1152) mainLeft.style.width = open ? "0" : "";
      else mainLeft.style.width = "";
      mainLeft.style.visibility = open ? "" : "visible";
    }

    if (mainRight) {
      mainRight.style["overflow-y"] = open ? "visible" : "hidden";
    }
  },
});
