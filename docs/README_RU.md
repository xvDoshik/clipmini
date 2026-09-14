[EN](../README.md) | RU

## clipmini 📋

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-14%2B-000000?style=flat-square&logo=apple&logoColor=white)
![license](https://img.shields.io/badge/license-MIT-green?style=flat-square)

**Минимальный clipboard manager для macOS** — иконка в menu bar, панель истории, глобальные шорткаты. Clean-room (не форк Maccy).

[Возможности](#-возможности) · [Управление](#-управление) · [Установка](#-установка) · [Архитектура](#-архитектура) · [Тесты](#-тесты)

---

## ✨ Возможности

- Захват текста и меток «картинка» с системного pasteboard
- Игнор confidential / transient / auto-generated типов
- Dedupe подряд одинакового текста; **30** записей в JSON на диске
- Иконка в menu bar (SF Symbol `doc.on.clipboard`)
- Клик по строке — вставка; автовставка через **⌘V** (Accessibility)

---

## ⌨️ Управление

| Действие | Шорткат |
|----------|---------|
| Открыть / закрыть панель | **⌘⇧V** |
| Вставить #1 / #2 / #3 | **⌘1** / **⌘2** / **⌘3** (пока панель открыта) |

При конфликте **⌘⇧V** отключи или измени шорткат в **Системные настройки → Клавиатура → Сочетания клавиш**.

---

## 🚀 Установка

### Сборка и запуск

```bash
git clone https://github.com/xvDoshik/clipmini.git
cd clipmini
swift build -c release
.build/release/ClipMini
```

Для отладки открой `Package.swift` в Xcode.

### Разрешения

**Конфиденциальность и безопасность → Универсальный доступ** — включи ClipMini (нужно для автоматической вставки).

---

## 🏗️ Архитектура

```text
PasteboardWatcher → HistoryStore
HotkeyCenter → AppController → HistoryPanel
AppController → PasteService → NSPasteboard / CGEvent
```

| Модуль | Назначение |
|--------|------------|
| `ClipMiniCore` | Модели, persistence, правила pasteboard |
| `ClipMini` | Menu bar, SwiftUI-панель, hotkeys, симуляция paste |

---

## 🧪 Тесты

```bash
swift run ClipMiniCoreTests
```

---

## 📜 Лицензия

MIT — см. [LICENSE](../LICENSE).
