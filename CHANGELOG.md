# Changelog

All notable changes to PeDitXOSui theme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-15

### Added
- 🎨 Modern dashboard UI design
- 🌓 Dark mode (default)
- ☀️ Light mode with theme toggle
- 📱 Fully responsive layout for desktop, tablet, and mobile
- 🧭 Bottom navigation bar for mobile devices
- 📊 Quick Status widget with animated progress circle
- 📈 Traffic Monitor chart (ready for integration)
- 📱 Connected Devices table with signal strength
- 📝 System Log viewer
- 🔧 Main Modules grid (WiFi, Devices, Traffic, Firewall, System Info, Updates)
- ⚡ Recent Activity feed
- 🎨 Glassmorphism design with blur effects
- 🔮 Animated background gradients
- 💾 Theme preference saved in localStorage
- 📦 UCI configuration support
- 🛠️ Customizable via UCI commands

### Changed
- Complete UI redesign from legacy theme
- Updated to modern CSS with CSS variables
- Improved mobile experience with bottom navbar
- Enhanced accessibility

### Fixed
- Responsive layout issues on small screens
- Theme persistence across page reloads
- Navigation state management

### Removed
- Legacy UI components
- Old CSS structure

## [0.9.0] - 2025-01-10

### Added
- Initial beta release
- Basic dark mode support
- Sidebar navigation

### Changed
- Migrated to new CSS architecture

### Fixed
- Various UI bugs

## [0.8.0] - 2025-01-05

### Added
- First development preview
- Basic theme structure
- Initial file organization

---

## Upgrade Notes

### From 0.x to 1.0.0

1. Backup your current configuration:
   ```bash
   uci export peditxosui > /tmp/peditxosui-backup.uci
   ```

2. Install the new version:
   ```bash
   opkg install luci-theme-peditxosui_1.0.0-r1_all.ipk
   ```

3. Restore your configuration (if needed):
   ```bash
   uci import peditxosui < /tmp/peditxosui-backup.uci
   uci commit peditxosui
   ```

4. Restart LuCI:
   ```bash
   /etc/init.d/uhttpd restart
   ```

---

## Support

- **Issues**: [GitHub Issues](https://github.com/peditx/luci-theme-peditxosui/issues)
- **Discussions**: [GitHub Discussions](https://github.com/peditx/luci-theme-peditxosui/discussions)
- **Telegram**: [@peditx](https://t.me/peditx)
