# 🎨 PeDitXOSui - Modern LuCI Theme for OpenWrt

<div align="center">

![PeDitXOSui](screenshots/preview.png)

**A modern, futuristic UI theme for OpenWrt's LuCI web interface**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-23.05-green.svg)](https://openwrt.org)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)]()

[العربية](README_fa.md) | [Русский](README_ru.md) | [中文](README_zh.md)

</div>

---

## ✨ Features

- 🌓 **Dark & Light Mode** - Easy theme switching with persistent preference
- 📱 **Fully Responsive** - Optimized for desktop, tablet, and mobile
- 🎯 **Modern Dashboard** - Clean, intuitive interface
- ⚡ **Fast & Lightweight** - Minimal dependencies
- 🎨 **Glassmorphism Design** - Beautiful blur effects and gradients
- 🔧 **Customizable** - Easy to configure via UCI
- 📊 **Real-time Status** - Quick access to system information
- 🧭 **Bottom Navbar** - Mobile-friendly navigation

## 📸 Screenshots

### Desktop (Dark Mode)
![Desktop Dark](screenshots/desktop-dark.png)

### Desktop (Light Mode)
![Desktop Light](screenshots/desktop-light.png)

### Mobile View
![Mobile](screenshots/mobile.png)

## 🚀 Installation

### Method 1: Using opkg (Recommended)

```bash
# Download the latest .ipk package from Releases
wget https://github.com/peditx/luci-theme-peditxosui/releases/latest/download/luci-theme-peditxosui_1.0.0-r1_all.ipk

# Install the package
opkg install luci-theme-peditxosui_1.0.0-r1_all.ipk

# Restart LuCI
/etc/init.d/uhttpd restart
```

### Method 2: Using install.sh

```bash
wget -O /tmp/install.sh https://raw.githubusercontent.com/peditx/luci-theme-peditxosui/main/install.sh
chmod +x /tmp/install.sh
/tmp/install.sh
```

### Method 3: Build from Source

```bash
# Clone the repository
git clone https://github.com/peditx/luci-theme-peditxosui.git
cd luci-theme-peDitXOSui

# Copy to OpenWrt build tree
cp -r . /path/to/openwrt/package/luci-theme-peditxosui

# Build the package
cd /path/to/openwrt
make package/luci-theme-peditxosui/compile V=s
```

## ⚙️ Configuration

After installation, you can configure the theme via UCI:

```bash
# Access theme settings
uci show peditxosui

# Change background color
uci set peditxosui.theme.color='#0a0e1a'

# Enable/disable navbar
uci set peditxosui.theme.navbar='1'

# Adjust blur effect (0-20)
uci set peditxosui.theme.blur='10'

# Commit changes
uci commit peditxosui
```

### Navbar Configuration

```bash
# Add a new navbar item
uci add peditxosui navbar
uci set peditxosui.@navbar[-1].name='Terminal'
uci set peditxosui.@navbar[-1].enable='Enable'
uci set peditxosui.@navbar[-1].line='1'
uci set peditxosui.@navbar[-1].newtab='No'
uci set peditxosui.@navbar[-1].icon='/www/luci-static/peditxosui/peds/icon/navbar/terminal.png'
uci set peditxosui.@navbar[-1].address='/cgi-bin/luci/admin/services/ttyd'
uci commit peditxosui
```

## 🎨 Features

### Quick Status Widget
- System online status with animated progress circle
- Download/Upload speed indicators
- Real-time network statistics

### Traffic Monitor
- Live traffic chart
- Historical data visualization
- Bandwidth usage tracking

### Connected Devices
- Device list with signal strength
- Device type icons
- IP address and MAC information

### System Log
- Real-time system logs
- Color-coded entries
- Easy scrolling

### Main Modules
- WiFi Settings
- Connected Devices
- Traffic Monitor
- Firewall
- System Info
- Software Updates

## 🛠️ Customization

### Colors

Edit `luasrc/style/peditxosui.css` to customize colors:

```css
:root {
    --accent-primary: #06b6d4;    /* Primary accent */
    --accent-secondary: #8b5cf6;  /* Secondary accent */
    --accent-success: #10b981;    /* Success/Online */
    --accent-warning: #f59e0b;    /* Warning */
    --accent-danger: #ef4444;     /* Error/Danger */
}
```

### Background

The theme uses animated gradient backgrounds. To modify:

```css
body::before {
    background:
        radial-gradient(ellipse at 20% 20%, rgba(6, 182, 212, 0.1) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%);
}
```

## 📁 Structure

```
luci-theme-peditxosui/
├── luasrc/
│   ├── style/
│   │   ├── peditxosui.css    # Main styles
│   │   ├── login.css         # Login page styles
│   │   └── navbar.css        # Navbar styles
│   ├── fonts/                # Custom fonts
│   ├── peds/                 # Ped files
│   └── app.js                # Main JavaScript
├── template/
│   ├── header.htm            # Page header
│   ├── footer.htm            # Page footer with navbar
│   └── sysauth.htm           # Login page
├── js/
│   └── menu-peditxosui.js    # Menu handler
├── root/
│   └── etc/
│       ├── config/peditxosui # UCI config
│       └── uci-defaults/     # First boot setup
├── Makefile                  # Build configuration
├── install.sh                # Installation script
└── README.md                 # This file
```

## 🔧 Dependencies

- LuCI 18.06+
- OpenWrt 19.07+
- libc

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**PeDitX** - [Telegram](https://t.me/peditx)

## 🙏 Acknowledgments

- [OpenWrt](https://openwrt.org) - The amazing Linux distribution
- [LuCI](https://github.com/openwrt/luci) - The web interface framework
- [luci-theme-bootstrap](https://github.com/openwrt/luci) - Base theme
- [luci-theme-material](https://github.com/LuttyYang/luci-theme-material) - Inspiration

---

<div align="center">

**Made with ❤️ for PeDitXOS**

[⬆ Back to Top](#-peDitxosui---modern-luci-theme-for-openwrt)

</div>
