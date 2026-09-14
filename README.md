EN | [RU](docs/README_RU.md)

## clipmini 📋

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-14%2B-000000?style=flat-square&logo=apple&logoColor=white)
![license](https://img.shields.io/badge/license-MIT-green?style=flat-square)

**Minimal macOS clipboard history** — menu bar app, floating panel, global shortcuts. Clean-room scope (not a Maccy fork).

[Features](#-features) · [Controls](#-controls) · [Setup](#-setup) · [Architecture](#-architecture) · [Tests](#-tests)

---

## ✨ Features

- Text capture and image placeholders from the system pasteboard
- Ignores concealed / transient / auto-generated pasteboard types
- Dedupes consecutive identical entries; **30** items persisted as JSON
- Menu bar icon (SF Symbol `doc.on.clipboard`)
- Click a row to paste; auto-paste via simulated **⌘V** (Accessibility)

---

## ⌨️ Controls

| Action | Shortcut |
|--------|----------|
| Toggle history panel | **⌘⇧V** |
| Paste item #1 / #2 / #3 | **⌘1** / **⌘2** / **⌘3** (while panel is open) |

If **⌘⇧V** conflicts with another app, change it under **System Settings → Keyboard → Keyboard Shortcuts**.

---

## 🚀 Setup

### Build & run

```bash
git clone https://github.com/xvDoshik/clipmini.git
cd clipmini
swift build -c release
.build/release/ClipMini
```

Open `Package.swift` in Xcode for debugging.

### Permissions

**System Settings → Privacy & Security → Accessibility** — enable ClipMini (required for automatic paste after selection).

---

## 🏗️ Architecture

```text
PasteboardWatcher → HistoryStore
HotkeyCenter → AppController → HistoryPanel
AppController → PasteService → NSPasteboard / CGEvent
```

| Module | Role |
|--------|------|
| `ClipMiniCore` | Models, persistence, pasteboard rules |
| `ClipMini` | Menu bar, SwiftUI panel, hotkeys, paste simulation |

---

## 🧪 Tests

```bash
swift run ClipMiniCoreTests
```

---

## 📜 License

MIT — see [LICENSE](LICENSE).
