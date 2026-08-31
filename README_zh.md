# 🎨 PeDitXOSui - 现代化 OpenWrt LuCI 主题

<div align="center">

![PeDitXOSui](screenshots/preview.png)

**一个现代、未来感的 OpenWrt LuCI Web 界面主题**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-23.05-green.svg)](https://openwrt.org)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)]()

[English](README.md) | [العربية](README_fa.md) | [Русский](README_ru.md)

</div>

---

## ✨ 特性

- 🌓 **深色和浅色模式** - 轻松切换主题并保存偏好设置
- 📱 **完全响应式** - 针对桌面、平板和移动设备优化
- 🎯 **现代仪表板** - 清晰直观的界面
- ⚡ **快速轻量** - 最小化依赖
- 🎨 **玻璃拟态设计** - 美丽的模糊效果和渐变
- 🔧 **可定制** - 通过 UCI 轻松配置
- 📊 **实时状态** - 快速访问系统信息
- 🧭 **底部导航栏** - 移动端友好的导航

## 📸 截图

### 桌面端（深色模式）
![Desktop Dark](screenshots/desktop-dark.png)

### 桌面端（浅色模式）
![Desktop Light](screenshots/desktop-light.png)

### 移动端视图
![Mobile](screenshots/mobile.png)

## 🚀 安装

### 方法 1：使用 opkg（推荐）

```bash
# 从 Releases 下载最新 .ipk 包
wget https://github.com/peditx/luci-theme-peditxosui/releases/latest/download/luci-theme-peditxosui_1.0.0-r1_all.ipk

# 安装包
opkg install luci-theme-peditxosui_1.0.0-r1_all.ipk

# 重启 LuCI
/etc/init.d/uhttpd restart
```

### 方法 2：使用 install.sh

```bash
wget -O /tmp/install.sh https://raw.githubusercontent.com/peditx/luci-theme-peditxosui/main/install.sh
chmod +x /tmp/install.sh
/tmp/install.sh
```

### 方法 3：从源码编译

```bash
# 克隆仓库
git clone https://github.com/peditx/luci-theme-peditxosui.git
cd luci-theme-peditxosui

# 复制到 OpenWrt 编译目录
cp -r . /path/to/openwrt/package/luci-theme-peditxosui

# 编译包
cd /path/to/openwrt
make package/luci-theme-peditxosui/compile V=s
```

## ⚙️ 配置

安装后，您可以通过 UCI 配置主题：

```bash
# 显示主题设置
uci show peditxosui

# 更改背景颜色
uci set peditxosui.theme.color='#0a0e1a'

# 启用/禁用导航栏
uci set peditxosui.theme.navbar='1'

# 调整模糊效果 (0-20)
uci set peditxosui.theme.blur='10'

# 提交更改
uci commit peditxosui
```

### 导航栏配置

```bash
# 添加新的导航栏项目
uci add peditxosui navbar
uci set peditxosui.@navbar[-1].name='终端'
uci set peditxosui.@navbar[-1].enable='Enable'
uci set peditxosui.@navbar[-1].line='1'
uci set peditxosui.@navbar[-1].newtab='No'
uci set peditxosui.@navbar[-1].icon='/www/luci-static/peditxosui/peds/icon/navbar/terminal.png'
uci set peditxosui.@navbar[-1].address='/cgi-bin/luci/admin/services/ttyd'
uci commit peditxosui
```

## 🎨 功能

### 快速状态小部件
- 带动画进度圈的系统在线状态
- 下载/上传速度指示器
- 实时网络统计

### 流量监控
- 实时流量图表
- 历史数据可视化
- 带宽使用跟踪

### 已连接设备
- 带信号强度的设备列表
- 设备类型图标
- IP 地址和 MAC 地址

### 系统日志
- 实时系统日志
- 彩色编码条目
- 轻松滚动

### 主要模块
- WiFi 设置
- 已连接设备
- 流量监控
- 防火墙
- 系统信息
- 软件更新

## 🛠️ 自定义

### 颜色

编辑 `luasrc/style/peditxosui.css` 自定义颜色：

```css
:root {
    --accent-primary: #06b6d4;    /* 主色调 */
    --accent-secondary: #8b5cf6;  /* 次要色调 */
    --accent-success: #10b981;    /* 成功/在线 */
    --accent-warning: #f59e0b;    /* 警告 */
    --accent-danger: #ef4444;     /* 错误/危险 */
}
```

### 背景

主题使用动画渐变背景。要修改：

```css
body::before {
    background:
        radial-gradient(ellipse at 20% 20%, rgba(6, 182, 212, 0.1) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%);
}
```

## 📁 结构

```
luci-theme-peditxosui/
├── luasrc/
│   ├── style/
│   │   ├── peditxosui.css    # 主样式
│   │   ├── login.css         # 登录页面样式
│   │   └── navbar.css        # 导航栏样式
│   ├── fonts/                # 自定义字体
│   ├── peds/                 # Ped 文件
│   └── app.js                # 主 JavaScript
├── template/
│   ├── header.htm            # 页面头部
│   ├── footer.htm            # 带导航栏的页面底部
│   └── sysauth.htm           # 登录页面
├── js/
│   └── menu-peditxosui.js    # 菜单处理器
├── root/
│   └── etc/
│       ├── config/peditxosui # UCI 配置
│       └── uci-defaults/     # 初始设置
├── Makefile                  # 编译配置
├── install.sh                # 安装脚本
└── README.md                 # 此文件
```

## 🔧 依赖

- LuCI 18.06+
- OpenWrt 19.07+
- libc

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

1. Fork 仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 许可证

本项目基于 Apache License 2.0 许可 - 详情请参阅 [LICENSE](LICENSE) 文件。

## 👨‍💻 作者

**PeDitX** - [Telegram](https://t.me/peditx)

## 🙏 致谢

- [OpenWrt](https://openwrt.org) - 惊人的 Linux 发行版
- [LuCI](https://github.com/openwrt/luci) - Web 界面框架
- [luci-theme-bootstrap](https://github.com/openwrt/luci) - 基础主题
- [luci-theme-material](https://github.com/LuttyYang/luci-theme-material) - 灵感来源

---

<div align="center">

**为 PeDitXOS 用心制作 ❤️**

[⬆ 返回顶部](#-peDitXOSui---现代化-openwrt-luci-主题)

</div>
