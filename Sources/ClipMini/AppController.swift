import AppKit
import ClipMiniCore

final class AppController: NSObject, NSApplicationDelegate, HotkeyHandler {
    private let store = HistoryStore()
    private let watcher = PasteboardWatcher()
    private let hotkeys = HotkeyCenter()
    private lazy var panelController = HistoryPanelController(store: store)
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        panelController.onPasteIndex = { [weak self] index in
            self?.paste(at: index)
        }

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "ClipMini")
        }
        rebuildMenu()

        watcher.onCapture = { [weak self] text, kind in
            Task { @MainActor in
                self?.store.append(text: text, kind: kind)
            }
        }
        watcher.start()
        hotkeys.install(handler: self)

        if !PasteService.accessibilityTrusted() {
            PasteService.requestAccessibility()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        watcher.stop()
        hotkeys.uninstall()
    }

    func handleHotkey(_ event: NSEvent) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let cmd = flags.contains(.command)
        let shift = flags.contains(.shift)

        if cmd && shift, event.charactersIgnoringModifiers?.lowercased() == "v" {
            panelController.toggle()
            return true
        }

        guard panelController.isVisible, cmd, !shift else { return false }
        guard let ch = event.charactersIgnoringModifiers, let digit = Int(ch), (1 ... 3).contains(digit) else {
            return false
        }
        paste(at: digit - 1)
        return true
    }

    private func paste(at index: Int) {
        guard let item = store.item(at: index) else { return }
        panelController.hide()
        PasteService.pasteItem(item)
    }

    private func rebuildMenu() {
        let menu = NSMenu()
        let showItem = NSMenuItem(title: "Show history (⌘⇧V)", action: #selector(menuShow), keyEquivalent: "")
        showItem.target = self
        menu.addItem(showItem)
        menu.addItem(.separator())
        let clearItem = NSMenuItem(title: "Clear history", action: #selector(menuClear), keyEquivalent: "")
        clearItem.target = self
        menu.addItem(clearItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit ClipMini", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc private func menuShow() {
        panelController.show()
    }

    @objc private func menuClear() {
        store.clear()
    }
}
