import AppKit
import ClipMiniCore
import SwiftUI

final class HistoryPanelController {
    private var panel: NSPanel?
    private let store: HistoryStore
    var onPasteIndex: ((Int) -> Void)?
    var isVisible: Bool { panel?.isVisible == true }

    init(store: HistoryStore) {
        self.store = store
    }

    func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }

    func show() {
        if panel == nil {
            buildPanel()
        }
        guard let panel else { return }
        NSApp.activate(ignoringOtherApps: true)
        panel.center()
        panel.makeKeyAndOrderFront(nil)
    }

    func hide() {
        panel?.orderOut(nil)
    }

    private func buildPanel() {
        let p = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 320),
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView, .utilityWindow],
            backing: .buffered,
            defer: false
        )
        p.isFloatingPanel = true
        p.level = .floating
        p.titleVisibility = .hidden
        p.titlebarAppearsTransparent = true
        p.isMovableByWindowBackground = true
        p.hidesOnDeactivate = false
        p.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let view = HistoryPanelView(store: store) { [weak self] index in
            self?.onPasteIndex?(index)
        }
        p.contentView = NSHostingView(rootView: view)
        panel = p
    }
}
