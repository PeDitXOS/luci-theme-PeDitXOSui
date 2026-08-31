# 🎨 PeDitXOSui - قالب مدرن LuCI برای OpenWrt

<div align="center">

![PeDitXOSui](screenshots/preview.png)

**یک قالب مدرن و فیوچریستیک برای رابط وب LuCI اپن‌ورت**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-23.05-green.svg)](https://openwrt.org)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)]()

[English](README.md) | [Русский](README_ru.md) | [中文](README_zh.md)

</div>

---

## ✨ ویژگی‌ها

- 🌓 **حالت تاریک و روشن** - تغییر آسان قالب با ذخیره ترجیحات
- 📱 **کاملاً ریسپانسیو** - بهینه شده برای دسکتاپ، تبلت و موبایل
- 🎯 **داشبورد مدرن** - رابط کاربری تمیز و بصری
- ⚡ **سریع و سبک** - وابستگی‌های حداقلی
- 🎨 **طراحی شیشه‌ای** - افکت‌های بلور و گرادیانت زیبا
- 🔧 **قابل تنظیم** - پیکربندی آسان از طریق UCI
- 📊 **وضعیت لحظه‌ای** - دسترسی سریع به اطلاعات سیستم
- 🧭 **نوار ناوبری پایین** - ناوبری سازگار با موبایل

## 📸 اسکرین‌شات‌ها

### دسکتاپ (حالت تاریک)
![Desktop Dark](screenshots/desktop-dark.png)

### دسکتاپ (حالت روشن)
![Desktop Light](screenshots/desktop-light.png)

### نمای موبایل
![Mobile](screenshots/mobile.png)

## 🚀 نصب

### روش ۱: با استفاده از opkg (پیشنهادی)

```bash
# دانلود آخرین نسخه .ipk از Releases
wget https://github.com/peditx/luci-theme-peditxosui/releases/latest/download/luci-theme-peditxosui_1.0.0-r1_all.ipk

# نصب پکیج
opkg install luci-theme-peditxosui_1.0.0-r1_all.ipk

# ریستارت LuCI
/etc/init.d/uhttpd restart
```

### روش ۲: با استفاده از install.sh

```bash
wget -O /tmp/install.sh https://raw.githubusercontent.com/peditx/luci-theme-peditxosui/main/install.sh
chmod +x /tmp/install.sh
/tmp/install.sh
```

### روش ۳: بیلد از سورس

```bash
# کلون ریپازیتوری
git clone https://github.com/peditx/luci-theme-peditxosui.git
cd luci-theme-peditxosui

# کپی به درخت بیلد اپن‌ورت
cp -r . /path/to/openwrt/package/luci-theme-peditxosui

# بیلد پکیج
cd /path/to/openwrt
make package/luci-theme-peditxosui/compile V=s
```

## ⚙️ پیکربندی

بعد از نصب، می‌توانید قالب را از طریق UCI پیکربندی کنید:

```bash
# نمایش تنظیمات قالب
uci show peditxosui

# تغییر رنگ پس‌زمینه
uci set peditxosui.theme.color='#0a0e1a'

# فعال/غیرفعال کردن نوار ناوبری
uci set peditxosui.theme.navbar='1'

# تنظیم افکت بلور (۰-۲۰)
uci set peditxosui.theme.blur='10'

# ذخیره تغییرات
uci commit peditxosui
```

### پیکربندی نوار ناوبری

```bash
# اضافه کردن آیتم جدید به نوار ناوبری
uci add peditxosui navbar
uci set peditxosui.@navbar[-1].name='ترمینال'
uci set peditxosui.@navbar[-1].enable='Enable'
uci set peditxosui.@navbar[-1].line='1'
uci set peditxosui.@navbar[-1].newtab='No'
uci set peditxosui.@navbar[-1].icon='/www/luci-static/peditxosui/peds/icon/navbar/terminal.png'
uci set peditxosui.@navbar[-1].address='/cgi-bin/luci/admin/services/ttyd'
uci commit peditxosui
```

## 🎨 ویژگی‌ها

### ویجت وضعیت سریع
- وضعیت آنلاین سیستم با دایره پیشرفت متحرک
- نشانگرهای سرعت دانلود/آپلود
- آمار شبکه لحظه‌ای

### مانیتور ترافیک
- نمودار ترافیک زنده
- تجسم داده‌های تاریخی
- ردیابی مصرف پهنای باند

### دستگاه‌های متصل
- لیست دستگاه‌ها با قدرت سیگنال
- آیکون‌های نوع دستگاه
- آدرس IP و MAC

### لاگ سیستم
- لاگ‌های سیستم لحظه‌ای
- ورودی‌ها با رنگ‌بندی
- اسکرول آسان

### ماژول‌های اصلی
- تنظیمات WiFi
- دستگاه‌های متصل
- مانیتور ترافیک
- فایروال
- اطلاعات سیستم
- به‌روزرسانی نرم‌افزار

## �یلی سفارشی‌سازی

### رنگ‌ها

فایل `luasrc/style/peditxosui.css` را ویرایش کنید:

```css
:root {
    --accent-primary: #06b6d4;    /* رنگ اصلی */
    --accent-secondary: #8b5cf6;  /* رنگ فرعی */
    --accent-success: #10b981;    /* موفقیت/آنلاین */
    --accent-warning: #f59e0b;    /* هشدار */
    --accent-danger: #ef4444;     /* خطا/خطر */
}
```

### پس‌زمینه

قالب از گرادیانت‌های متحرک پس‌زمینه استفاده می‌کند. برای تغییر:

```css
body::before {
    background:
        radial-gradient(ellipse at 20% 20%, rgba(6, 182, 212, 0.1) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%);
}
```

## 📁 ساختار

```
luci-theme-peditxosui/
├── luasrc/
│   ├── style/
│   │   ├── peditxosui.css    # استایل‌های اصلی
│   │   ├── login.css         # استایل صفحه ورود
│   │   └── navbar.css        # استایل نوار ناوبری
│   ├── fonts/                # فونت‌های سفارشی
│   ├── peds/                 # فایل‌های پد
│   └── app.js                # جاوااسکریپت اصلی
├── template/
│   ├── header.htm            # هدر صفحه
│   ├── footer.htm            # فوتر با نوار ناوبری
│   └── sysauth.htm           # صفحه ورود
├── js/
│   └── menu-peditxosui.js    # مدیریت منو
├── root/
│   └── etc/
│       ├── config/peditxosui # پیکربندی UCI
│       └── uci-defaults/     # راه‌اندازی اولیه
├── Makefile                  # پیکربندی بیلد
├── install.sh                # اسکریپت نصب
└── README.md                 # این فایل
```

## 🔧 وابستگی‌ها

- LuCI 18.06+
- OpenWrt 19.07+
- libc

## 🤝 مشارکت

مشارکت شما خوشآمدید! لطفاً آزادانه یک Pull Request ارسال کنید.

1. ریپازیتوری را Fork کنید
2. شاخه ویژگی خود را ایجاد کنید (`git checkout -b feature/AmazingFeature`)
3. تغییرات خود را Commit کنید (`git commit -m 'Add some AmazingFeature'`)
4. به شاخه Push کنید (`git push origin feature/AmazingFeature`)
5. یک Pull Request باز کنید

## 📝 مجوز

این پروژه تحت مجوز Apache License 2.0 است - جزئیات را در فایل [LICENSE](LICENSE) مشاهده کنید.

## 👨‍💻 نویسنده

**PeDitX** - [تلگرام](https://t.me/peditx)

## 🙏 قدردانی

- [OpenWrt](https://openwrt.org) - توزیع لینوکس شگفت‌انگیز
- [LuCI](https://github.com/openwrt/luci) - چارچوب رابط وب
- [luci-theme-bootstrap](https://github.com/openwrt/luci) - قالب پایه
- [luci-theme-material](https://github.com/LuttyYang/luci-theme-material) - الهام‌بخش

---

<div align="center">

**ساخته شده با ❤️ برای PeDitXOS**

[⬆ بازگشت به بالا](#-peDitXOSui---قالب-مدرن-luci-برای-openwrt)

</div>
