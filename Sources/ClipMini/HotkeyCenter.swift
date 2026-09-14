import AppKit

protocol HotkeyHandler: AnyObject {
    func handleHotkey(_ event: NSEvent) -> Bool
}

final class HotkeyCenter {
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private weak var handler: HotkeyHandler?

    func install(handler: HotkeyHandler) {
        uninstall()
        self.handler = handler
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            _ = self?.handler?.handleHotkey(event)
        }
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.handler?.handleHotkey(event) == true {
                return nil
            }
            return event
        }
    }

    func uninstall() {
        if let globalMonitor { NSEvent.removeMonitor(globalMonitor) }
        if let localMonitor { NSEvent.removeMonitor(localMonitor) }
        globalMonitor = nil
        localMonitor = nil
        handler = nil
    }
}
