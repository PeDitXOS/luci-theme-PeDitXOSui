# 🎨 PeDitXOSui - Современная тема LuCI для OpenWrt

<div align="center">

![PeDitXOSui](screenshots/preview.png)

**Современная фиолетовая тема для веб-интерфейса LuCI OpenWrt**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-23.05-green.svg)](https://openwrt.org)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)]()

[English](README.md) | [العربية](README_fa.md) | [中文](README_zh.md)

</div>

---

## ✨ Особенности

- 🌓 **Тёмный и светлый режим** - Простое переключение с сохранением настроек
- 📱 **Полностью адаптивный** - Оптимизирован для десктопа, планшета и мобильных устройств
- 🎯 **Современная панель управления** - Чистый и интуитивный интерфейс
- ⚡ **Быстрый и лёгкий** - Минимальные зависимости
- 🎨 **Дизайн "стекломорфизм"** - Красивые эффекты размытия и градиенты
- 🔧 **Настраиваемый** - Простая конфигурация через UCI
- 📊 **Статус в реальном времени** - Быстрый доступ к информации о системе
- 🧭 **Нижняя панель навигации** - Удобная навигация для мобильных устройств

## 📸 Скриншоты

### Десктоп (Тёмный режим)
![Desktop Dark](screenshots/desktop-dark.png)

### Десктоп (Светлый режим)
![Desktop Light](screenshots/desktop-light.png)

### Мобильный вид
![Mobile](screenshots/mobile.png)

## 🚀 Установка

### Способ 1: С помощью opkg (Рекомендуется)

```bash
# Скачать последний .ipk пакет из Releases
wget https://github.com/peditx/luci-theme-peditxosui/releases/latest/download/luci-theme-peditxosui_1.0.0-r1_all.ipk

# Установить пакет
opkg install luci-theme-peditxosui_1.0.0-r1_all.ipk

# Перезапустить LuCI
/etc/init.d/uhttpd restart
```

### Способ 2: С помощью install.sh

```bash
wget -O /tmp/install.sh https://raw.githubusercontent.com/peditx/luci-theme-peditxosui/main/install.sh
chmod +x /tmp/install.sh
/tmp/install.sh
```

### Способ 3: Сборка из исходников

```bash
# Клонировать репозиторий
git clone https://github.com/peditx/luci-theme-peditxosui.git
cd luci-theme-peditxosui

# Скопировать в дерево сборки OpenWrt
cp -r . /path/to/openwrt/package/luci-theme-peditxosui

# Собрать пакет
cd /path/to/openwrt
make package/luci-theme-peditxosui/compile V=s
```

## ⚙️ Конфигурация

После установки вы можете настроить тему через UCI:

```bash
# Показать настройки темы
uci show peditxosui

# Изменить цвет фона
uci set peditxosui.theme.color='#0a0e1a'

# Включить/выключить панель навигации
uci set peditxosui.theme.navbar='1'

# Настроить эффект размытия (0-20)
uci set peditxosui.theme.blur='10'

# Сохранить изменения
uci commit peditxosui
```

### Конфигурация панели навигации

```bash
# Добавить новый элемент в панель навигации
uci add peditxosui navbar
uci set peditxosui.@navbar[-1].name='Терминал'
uci set peditxosui.@navbar[-1].enable='Enable'
uci set peditxosui.@navbar[-1].line='1'
uci set peditxosui.@navbar[-1].newtab='No'
uci set peditxosui.@navbar[-1].icon='/www/luci-static/peditxosui/peds/icon/navbar/terminal.png'
uci set peditxosui.@navbar[-1].address='/cgi-bin/luci/admin/services/ttyd'
uci commit peditxosui
```

## 🎨 Возможности

### Виджет быстрого статуса
- Статус онлайн системы с анимированным кругом прогресса
- Индикаторы скорости загрузки/выгрузки
- Сетевая статистика в реальном времени

### Монитор трафика
- Живой график трафика
- Визуализация исторических данных
- Отслеживание использования пропускной способности

### Подключённые устройства
- Список устройств с указанием силы сигнала
- Иконки типов устройств
- IP-адреса и MAC-адреса

### Системный журнал
- Системные логи в реальном времени
- Цветовая кодировка записей
- Удобная прокрутка

### Основные модули
- Настройки WiFi
- Подключённые устройства
- Монитор трафика
- Фаервол
- Информация о системе
- Обновления программного обеспечения

## 🛠️ Настройка

### Цвета

Отредактируйте файл `luasrc/style/peditxosui.css`:

```css
:root {
    --accent-primary: #06b6d4;    /* Основной цвет */
    --accent-secondary: #8b5cf6;  /* Вторичный цвет */
    --accent-success: #10b981;    /* Успех/Онлайн */
    --accent-warning: #f59e0b;    /* Предупреждение */
    --accent-danger: #ef4444;     /* Ошибка/Опасность */
}
```

### Фон

Тема использует анимированные градиенты фона. Для изменения:

```css
body::before {
    background:
        radial-gradient(ellipse at 20% 20%, rgba(6, 182, 212, 0.1) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%);
}
```

## 📁 Структура

```
luci-theme-peditxosui/
├── luasrc/
│   ├── style/
│   │   ├── peditxosui.css    # Основные стили
│   │   ├── login.css         # Стили страницы входа
│   │   └── navbar.css        # Стили панели навигации
│   ├── fonts/                # Пользовательские шрифты
│   ├── peds/                 # Файлы ped
│   └── app.js                # Основной JavaScript
├── template/
│   ├── header.htm            # Заголовок страницы
│   ├── footer.htm            # Подвал с панелью навигации
│   └── sysauth.htm           # Страница входа
├── js/
│   └── menu-peditxosui.js    # Обработчик меню
├── root/
│   └── etc/
│       ├── config/peditxosui # Конфигурация UCI
│       └── uci-defaults/     # Начальная настройка
├── Makefile                  # Конфигурация сборки
├── install.sh                # Скрипт установки
└── README.md                 # Этот файл
```

## 🔧 Зависимости

- LuCI 18.06+
- OpenWrt 19.07+
- libc

## 🤝 Участие

Ваш вклад приветствуется! Пожалуйста, создавайте Pull Request'ы.

1. Форкните репозиторий
2. Создайте ветку функции (`git checkout -b feature/AmazingFeature`)
3. Зафиксируйте изменения (`git commit -m 'Add some AmazingFeature'`)
4. Отправьте в ветку (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

## 📝 Лицензия

Этот проект лицензирован под лицензией Apache License 2.0 - подробности см. в файле [LICENSE](LICENSE).

## 👨‍💻 Автор

**PeDitX** - [Telegram](https://t.me/peditx)

## 🙏 Благодарности

- [OpenWrt](https://openwrt.org) - Удивительный дистрибутив Linux
- [LuCI](https://github.com/openwrt/luci) - Фреймворк веб-интерфейса
- [luci-theme-bootstrap](https://github.com/openwrt/luci) - Базовая тема
- [luci-theme-material](https://github.com/LuttyYang/luci-theme-material) - Вдохновение

---

<div align="center">

**Сделано с ❤️ для PeDitXOS**

[⬆ Наверх](#-peDitXOSui---современная-тема-luci-для-openwrt)

</div>
